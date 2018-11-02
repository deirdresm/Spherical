//
//  Primitives.swift
//  Spherical
//
//  Created by Deirdre Saoirse Moen on 10/25/18.
//  Copyright © 2018 Deirdre Saoirse Moen. All rights reserved.
//

import Foundation
import SceneKit
import RealmSwift


func +(left:CGFloat, right:Float) -> CGFloat
{ return left + CGFloat(right) }

func +(left:Float, right:CGFloat) -> CGFloat
{ return CGFloat(left) + right }

func <(left:CGFloat, right:Float) -> Bool
{ return left < CGFloat(right) }

func <(left:Float, right:CGFloat) -> Bool
{ return CGFloat(left) < right }

func >(left:CGFloat, right:Float) -> Bool
{ return left > CGFloat(right) }

func >(left:Float, right:CGFloat) -> Bool
{ return CGFloat(left) > right }

class PrimitivesScene : SCNScene {

//	var jsonColors : [JSONcolors] = []

	var bigSphereNode : SCNNode?
	let bigSphereRadius : CGFloat = 0.95 // radius
	let littleSphereRadius : CGFloat = 0.05 // TODO: should calculate to adjust this
	let cameraNode = SCNNode()          // the camera

	let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
		//Leave the block empty
	}

	lazy var realm:Realm = {
		Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 0, migrationBlock: migrationBlock)
		return try! Realm()
	}()
	
	
	override init() {
		super.init()
		
		print(Realm.Configuration.defaultConfiguration.fileURL)

		// add the container node containing all model elements
		
		let keyLight = SCNLight()       ;   let keyLightNode = SCNNode()
		let ambientLight = SCNLight()   ;   let ambientLightNode = SCNNode()
		
		cameraNode.camera = SCNCamera()
		cameraNode.position = SCNVector3Make(0, 0, 5)
		rootNode.addChildNode(cameraNode)
		
		keyLight.type = SCNLight.LightType.omni
		keyLightNode.light = keyLight
		keyLightNode.position = SCNVector3(x: 5, y: 5, z: 3)
		cameraNode.addChildNode(keyLightNode)
		
		ambientLight.type = SCNLight.LightType.ambient

		let shade: CGFloat = 0.40
		ambientLight.color = UIColor(red: shade, green: shade, blue: shade, alpha: 1.0)
		ambientLightNode.light = ambientLight
		cameraNode.addChildNode(ambientLightNode)
				
		var shadowColors = realm.objects(ShadowColor.self)
		
		print("creating big sphere")
		bigSphereNode = createBigSphere()
		rootNode.addChildNode(bigSphereNode!)
		print(bigSphereNode?.geometry)
		
//		print("creating the camera node")
//		createCameraNode()
		
		print("attaching imported colors to boundaries of big sphere")
		for shadowColor in shadowColors {
			attachColorToBigSphere(shadowColor)
		}

	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	func createBigSphere() -> SCNNode {
		let sphereGeometry = SCNSphere(radius: bigSphereRadius)
		sphereGeometry.firstMaterial!.diffuse.contents = UIColor.darkGray
		bigSphereNode = SCNNode(geometry: sphereGeometry)
		
//		bigSphereNode!.opacity = 0.5 // fully transparent
		
		rootNode.addChildNode(bigSphereNode!)
		
		return bigSphereNode!
		
	}
	
	func attachColorToBigSphere(_ shadowColor: ShadowColor) {
		
		// calculate geometry and position
		let sphereGeometry = SCNSphere(radius: littleSphereRadius)

		// add color
		
		sphereGeometry.firstMaterial!.diffuse.contents = UIColor.init(hue: CGFloat(shadowColor.hue), saturation: CGFloat(shadowColor.saturation), brightness: CGFloat(shadowColor.brightness), alpha: 1.0)
		sphereGeometry.firstMaterial!.lightingModel = .phong
		
		// add geometry to sphere

		let sphereNode = SCNNode(geometry: sphereGeometry)
		sphereNode.opacity = 1.0 // fully opaque
		sphereNode.position = calcPosition(shadowColor)
		
		print("little sphere position: X: \(sphereNode.position.x), y: \(sphereNode.position.y), z: \(sphereNode.position.z)\noriginally hue \(shadowColor.hue), bright \(shadowColor.brightness), sat \(shadowColor.saturation)")
		
		// add to big sphere
		
		bigSphereNode?.addChildNode(sphereNode)
	}
	
	func calcPosition(_ shadowColor: ShadowColor) -> SCNVector3 {

		
		// shadowColor will have 0.0-1.0 for degrees x, y and z have no negatives, so use half a circle?,
		// which I'll be ignoring for now until I get the rest sorted.
		
		// x, y, and z need to be in radians
		// x is full circumference, so 2 pi radians. We have degrees / 360.
		// let x = Float(shadowColor.hue) * Float(bigSphereRadius)
//		let x = Float(360.0 * (shadowColor.hue - 0.5)) / (180 * Float.pi)
		let x = Float(shadowColor.hue - 0.5)

		// y is half circumference (as negative brightness makes no sense), so pi radians and we have degrees / 180.
		
//		let y = Float(2.0*(shadowColor.brightness-0.5)) * Float(bigSphereRadius)
//		let y = Float(shadowColor.brightness) * Float(bigSphereRadius)
		let y = Float(shadowColor.brightness - 0.5)
//		let y = Float(shadowColor.brightness) / Float.pi

		// z confuses me. It's saturation, so that's from 0.0 to 1.0 and much like y, except that…nevermind

//		let z = Float(shadowColor.saturation) * Float(bigSphereRadius)
//		let z = 2.0 + ((Float(shadowColor.saturation)-0.5) / Float.pi)
		let z = 2.0 + ((Float(shadowColor.saturation)-0.5))

		let vector = SCNVector3(x: x, y: y, z: z)
		
		return vector
	}

/*	func drawSphere() {
		let sphereGeometry = SCNSphere(radius: 1.0)
		let sphereNode = SCNNode(geometry: sphereGeometry)
		
		let material = SCNMaterial()
		material.diffuse.contents = UIImage(named: "8-Lime Time")
		material.lightingModel = .phong

//		let scaleX = (Float(self.bounds.width)  / 0.02).rounded()
//		let scaleY = (Float(self.bounds.width) / 0.02).rounded()
		
		// TODO: figure out a better way of calculating this
		material.diffuse.contentsTransform = SCNMatrix4MakeScale(10.0, 10.0, 0)

		material.diffuse.wrapS = SCNWrapMode.repeat
		material.diffuse.wrapT = SCNWrapMode.repeat

		sphereGeometry.materials = [material]
		self.rootNode.addChildNode(sphereNode)
	}
*/
	
}

