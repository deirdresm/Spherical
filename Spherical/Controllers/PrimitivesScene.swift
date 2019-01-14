//
//  Primitives.swift
//  Spherical
//
//  Created by Deirdre Saoirse Moen on 10/25/18.
//  Copyright © 2018 Deirdre Saoirse Moen. All rights reserved.
//

import Foundation
import SceneKit
import CoreData

class PrimitivesScene : SCNScene, SCNSceneRendererDelegate {

	//	let sceneRenderer: SCNSceneRenderer // TODO: for later animation
	
	var vc : UIViewController?

	var mainSphereNode : SCNNode?
	let mainSphereRadius : CGFloat = 2.0 // radius
	let littleSphereRadius : CGFloat = 0.075 // TODO: should calculate to adjust this
	let cameraNode = SCNNode()          // the camera
	private var shadowColors: [NSManagedObject] = []
	
	var makerDict : NSMutableDictionary = [:]

	override init() {
		super.init()
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		
		let moc = appDelegate.persistentContainer.viewContext

		let shadowFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ShadowColor")
		let nameSort = NSSortDescriptor(key: "name", ascending: true)
		
		shadowFetchRequest.sortDescriptors = [nameSort]
		
		do {
			self.shadowColors = try moc.fetch(shadowFetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		
		// add the container node containing all model elements
		
/*		let keyLight = SCNLight()       ;   let keyLightNode = SCNNode()
		let ambientLight = SCNLight()   ;   let ambientLightNode = SCNNode()
		
		cameraNode.camera = SCNCamera()
		cameraNode.position = SCNVector3Make(0, 0, 10)
		rootNode.addChildNode(cameraNode)
		
		keyLight.type = SCNLight.LightType.omni
		keyLightNode.light = keyLight
		keyLightNode.position = SCNVector3(x: 5, y: 5, z: 3)
		
		keyLightNode.constraints = []
		cameraNode.addChildNode(keyLightNode)
		
		ambientLight.type = SCNLight.LightType.ambient

		let shade: CGFloat = 0.40
		ambientLight.color = UIColor(red: shade, green: shade, blue: shade, alpha: 1.0)
		ambientLightNode.light = ambientLight
		cameraNode.addChildNode(ambientLightNode)
*/
		print("creating big sphere")
//		mainSphereNode = createBigSphere()
		mainSphereNode = rootNode
//		rootNode.addChildNode(mainSphereNode!)
///		print(rootNode.geometry)
		
//		print("creating the camera node")
//		createCameraNode()
		
		print("attaching imported colors to boundaries of big sphere")
		for shadowColor in shadowColors {
			attachColorToBigSphere(shadowColor as! ShadowColor)
		}

	}

	// TODO: required initializer that should be fleshed out
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func getMakerName(sc: ShadowColor) -> String {
		return sc.eyePalette!.maker!.name
	}
	
	// adds maker node to dictionary if it doesn't exist, then adds it to the main node.
	// purpose: to be able to animate by maker/palette
	
	func findMakerNode(_ sc: ShadowColor) -> SCNNode {
		
		let name = getMakerName(sc: sc)
		
		if let sphereNode = makerDict[name] {
			return sphereNode as! SCNNode	 // it's already added to the main node
		} else {
			let sphereGeometry = SCNSphere(radius: littleSphereRadius)
			let sphereNode = SCNNode(geometry: sphereGeometry)
			sphereNode.opacity = 1.0 // fully opaque
			sphereNode.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
			mainSphereNode?.addChildNode(sphereNode)
			makerDict[name] = sphereNode
			
			return sphereNode
		}
	}

	// the "big sphere" here is virtual: essentially the colors are being added to a sphere.
	// I didn't realize that making that sphere transparent would also make chld nodes
	// transparent, but that makes sense. So we change it up.
	
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
		
		// add to maker sphere
		
		let makerNode = findMakerNode(shadowColor)
		
		makerNode.addChildNode(sphereNode)
	}
	
	func calcPosition(_ shadowColor: ShadowColor) -> SCNVector3 {

		
		// shadowColor will have 0.0-1.0 for degrees x, y and z have no negatives, so use half a circle
//
//		// x, y, and z need to be converted to radians first
//
//		let radius : Float = Float(bigSphereRadius) + (1.25 * Float(shadowColor.saturation)) - 0.5
//
//		let sRadians = 2.0 * Float(shadowColor.hue * Double.pi)
//		let tRadians = Float(shadowColor.brightness * Double.pi)
//
//		let x = Float(radius) * cos(sRadians) * sin(tRadians)
//		let y = Float(radius) * cos(tRadians)
//		let z = Float(radius) * sin(sRadians) * sin(tRadians)

		let vector = SCNVector3(x: Float(shadowColor.x), y: Float(shadowColor.y), z: Float(shadowColor.z))
		
		return vector
	}
	
	func animateSphere() {
		
	}


}

