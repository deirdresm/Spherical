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
	let makerSphereRadius : CGFloat = 0.000075 // TODO: should calculate to adjust this
	let cameraNode = SCNNode()          // the camera
	var twinkleNode = SphereScnNode()
	private var shadowColors: [NSManagedObject] = []
	
	var makerDict : NSMutableDictionary = [:]
	var makerNameArray : [String] = []
	var currentMaker = 0
	
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

		mainSphereNode = rootNode
		
		rotateSphere() // Attach the animation to the node to start it.
		
		// Attach colors to the main node via Maker. Note that there's a join in the middle
		// not used in this app. Adding them this way will allow the app to animate by maker,
		// which was my goal here.

		for shadowColor in shadowColors {
			attachColorToMaker(shadowColor as! ShadowColor)
		}

		scheduleMakerAnimations()
	}

	// TODO: required initializer that should be fleshed out
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// Have to reach through the middle relation to get the maker name from the shadow color instance.
	
	func getMakerName(sc: ShadowColor) -> String {
		return sc.eyePalette!.maker!.name
	}
	
	// adds maker node to dictionary if it doesn't exist, then adds it to the main node.
	// returns the found or created sphereNode.
	
	// TODO: it might be cool at some later time to make the maker node's location the median
	// point between all the colors. Not sure what I'd do with that, but it's an interesting idea.
	
	func findMakerNode(_ sc: ShadowColor) -> SCNNode {
		
		let name = getMakerName(sc: sc)
		
		if let sphereNode = makerDict[name] {
			return sphereNode as! SCNNode	 // it's already added to the main node
		} else {
			let sphereGeometry = SCNSphere(radius: makerSphereRadius)
			sphereGeometry.firstMaterial!.diffuse.contents = UIColor.black
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
	
	func attachColorToMaker(_ shadowColor: ShadowColor) {
		
		// calculate geometry and position
		let sphereGeometry = SCNSphere(radius: littleSphereRadius)

		// add color
		
		sphereGeometry.firstMaterial!.diffuse.contents = UIColor.init(hue: CGFloat(shadowColor.hue), saturation: CGFloat(shadowColor.saturation), brightness: CGFloat(shadowColor.brightness), alpha: 1.0)
		sphereGeometry.firstMaterial!.lightingModel = .phong
		
		// add geometry to sphere

		let sphereNode = SCNNode(geometry: sphereGeometry)
//		sphereNode.opacity = 0.0 // fully transparent (at the start)
		sphereNode.position = calcPosition(shadowColor)
		
		// add to maker sphere
		
		let makerNode = findMakerNode(shadowColor)
		makerNode.addChildNode(sphereNode)
	}
	
	func calcPosition(_ shadowColor: ShadowColor) -> SCNVector3 {

		// precalculated when color was added to CoreData, but that could change if desired
		
		let vector = SCNVector3(x: Float(shadowColor.x), y: Float(shadowColor.y), z: Float(shadowColor.z))
		
		return vector
	}
	
	
	// MARK: Core Animation-fu


	func scheduleMakerAnimations() {
		// get list of maker names, sorted
		makerNameArray = (makerDict.allKeys).sorted(by: { ($0 as! String) < ($1 as! String) }) as! [String]
		
		let localTime = CACurrentMediaTime() // get this number as late as possible
		
		if currentMaker >= makerNameArray.count {
			currentMaker = 0
		}

//		var twinkleAnimationGroup = CABasicAnimation(keyPath: "TwinkleGroup")
//		var twinkleArray : [CAAnimation] = []

		for makerName in makerNameArray {
			
			let twinkleAnimation = CABasicAnimation(keyPath: "opacity")
			let twinkleNode = makerDict[makerName] as! SCNNode
			
			// Animate one complete revolution around the node's Y axis.
			
			twinkleAnimation.fromValue =  0.0
			twinkleAnimation.toValue =  1.0
			twinkleAnimation.duration = 2.0 // take two whole seconds
			twinkleAnimation.autoreverses = true

			twinkleNode.addAnimation(twinkleAnimation, forKey: "opacity-\(makerName)")
			
//			twinkleArray.append(twinkleAnimation)
		}
//		twinkleAnimationGroup.repeatCount = .greatestFiniteMagnitude // Repeat the animation forever.

	}

	fileprivate func rotateSphere() {
		// rotate the root node
		
		let rotationAnimation = CABasicAnimation(keyPath: "rotation")
		
		// Animate one complete revolution around the node's Y axis.
		
		let π = Double.pi
		
		rotationAnimation.toValue =  NSValue(scnVector4: SCNVector4(0, -1, 0, 2 * π))
		rotationAnimation.duration = 5.0 // One revolution in five seconds.
		rotationAnimation.repeatCount = .greatestFiniteMagnitude // Repeat the animation forever.
		rootNode.addAnimation(rotationAnimation, forKey: "opacity")
	}
}

