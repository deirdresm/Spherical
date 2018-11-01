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
	
	var minH : Float = 1000.0
	var minS : Float = 1000.0
	var minB : Float = 1000.0
	
	var maxH : Float = 0.0
	var maxS : Float = 0.0
	var maxB : Float = 0.0
	
	var minX : Float = 1000.0
	var minY : Float = 1000.0
	var minZ : Float = 1000.0
	
	var maxX : Float = 0.0
	var maxY : Float = 0.0
	var maxZ : Float = 0.0


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

		var shadowColors = realm.objects(ShadowColor.self)
		
		print("creating big sphere")
		bigSphereNode = createBigSphere()
		
		print("attaching imported colors")
		for shadowColor in shadowColors {
			attachColorToBigSphere(shadowColor)
		}
		
		print("min/max hue \(minH), \(maxH)\nsat \(minS), \(maxS)\nbright \(minB), \(maxB)\nx \(minX), \(maxX)\ny \(minY), \(maxY)\nz \(minZ), \(maxZ)")

		
		print("adding directional lighting")
		addDirectionalLighting()
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func createBigSphere() -> SCNNode {
		let sphereGeometry = SCNSphere(radius: bigSphereRadius)
		bigSphereNode = SCNNode(geometry: sphereGeometry)
		
/*		let material = SCNMaterial()
		material.diffuse.contents = UIImage(named: "8-Lime Time")
		material.lightingModel = .phong
		
		// TODO: figure out a better way of calculating this
		material.diffuse.contentsTransform = SCNMatrix4MakeScale(10.0, 10.0, 0)
		
		material.diffuse.wrapS = SCNWrapMode.repeat
		material.diffuse.wrapT = SCNWrapMode.repeat
		
		sphereGeometry.materials = [material]
*/
		return bigSphereNode!
		
	}
	
	func attachColorToBigSphere(_ shadowColor: ShadowColor) {
		
		// calculate geometry and position
		let sphereGeometry = SCNSphere(radius: littleSphereRadius)
		let sphereNode = SCNNode(geometry: sphereGeometry)
		
		sphereNode.position = calcPosition(shadowColor)
		
		// add color
		
		let material = SCNMaterial()
		material.diffuse.contents = UIColor.init(hue: CGFloat(shadowColor.hue), saturation: CGFloat(shadowColor.saturation), brightness: CGFloat(shadowColor.brightness), alpha: 1.0)
		
		// add lighting
		
		bigSphereNode?.addChildNode(sphereNode)
	}
	
	func calcPosition(_ shadowColor: ShadowColor) -> SCNVector3 {
		
		// shadowColor will have 0.0-1.0 for degrees x, y and z have no negatives, so use half a circle?,
		// which I'll be ignoring for now until I get the rest sorted.
		
		// x, y, and z need to be in radians
		// x is full circumference, so 2 pi radians. We have degrees / 360.
		let x = Float(2.0 * shadowColor.hue) * Float.pi
		
		// y is half circumference (as negative brightness makes no sense), so pi radians and we have degrees / 180.
		
		let y = Float(180.0 * shadowColor.brightness) * (Float.pi / 90.0)
		
		// z confuses me. It's saturation, so that's from 0.0 to 1.0 and much like y, except that 

		let z = Float(180.0 * shadowColor.saturation) * (Float.pi / 90.0)
		
		minX = x < minX ? Float(x) : minX
		minY = y < minY ? Float(y) : minY
		minZ = z < minZ ? Float(z) : minZ
		
		maxX = x > maxX ? x : maxX
		maxY = y > maxY ? y : maxY
		maxZ = z > maxZ ? z : maxZ
		
		minH = CGFloat(shadowColor.hue) < minH ? Float(shadowColor.hue) : minH
		minS = CGFloat(shadowColor.saturation) < minS ? Float(shadowColor.saturation) : minS
		minB = CGFloat(shadowColor.brightness) < minB ? Float(shadowColor.brightness) : minB
		
		maxH = CGFloat(shadowColor.hue) > maxH ? Float(shadowColor.hue) : maxH
		maxS = CGFloat(shadowColor.saturation) > maxS ? Float(shadowColor.saturation) : maxS
		maxB = CGFloat(shadowColor.brightness) > maxB ? Float(shadowColor.brightness) : maxB

		let vector = SCNVector3(x: x, y: y, z: z)
		print("color hue \(shadowColor.hue), sat \(shadowColor.saturation), bright \(shadowColor.brightness) = x \(x), y \(y), z \(z)")
		
		return vector
	}

	func drawSphere() {
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
		addDirectionalLighting()
		self.rootNode.addChildNode(sphereNode)
	}

	func addDirectionalLighting() {
		
		let directionalLight = SCNLight()
		directionalLight.type = .directional
		let directionalNode = SCNNode()
		directionalNode.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-130), GLKMathDegreesToRadians(0), GLKMathDegreesToRadians(35))
		directionalNode.light = directionalLight
		self.rootNode.addChildNode(directionalNode)
	}
}

