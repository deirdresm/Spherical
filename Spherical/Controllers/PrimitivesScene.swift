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
	
	// TODO: break this out where it makes sense to.

	var vc : ViewController?

	let mainSphereRadius : CGFloat = 2.0 // radius
	let littleSphereRadius : CGFloat = 0.075
	let makerSphereRadius : CGFloat = 0.000075
	let cameraNode = SCNNode()          // the camera
	private var shadowColors: [ShadowColor] = []
	let makerAnimationDuration : Double = 8.0
	
//	var makerDict : NSMutableDictionary = [:]
	var currentMaker = 0
	var textGeometry = SCNText(string: "", extrusionDepth: 0.2)
	var makerNameNode = MakerNameNode(makerName: "")		// the title

	var makersOrig = [Maker]()
	var makersCulled = [Maker]()
	var makerNodes = [SCNNode]()

	override init() {
		super.init()
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		
		let moc = appDelegate.persistentContainer.viewContext
		
		
		let makerFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Maker")
		let nameSort = NSSortDescriptor(key: "name", ascending: true)
		makerFetchRequest.sortDescriptors = [nameSort]
		
		do {
			makersOrig = try (moc.fetch(makerFetchRequest) as? [Maker])!
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
		
		makerNameNode.geometry = textGeometry
		
		rootNode.addChildNode(makerNameNode)
		
		// count backwards to make array shortening easier.
		
		print("makers.count = \(makersOrig.count)")
		
		for index in 0..<makersOrig.count {
			let maker = makersOrig[index]
			if maker.numShadowColors() >= 20 {	// too few items to bother graphing
				makersCulled.append(maker)
			}
		}
		
		print("makers.count = \(makersOrig.count) vs. culled = \(makersCulled.count)")
		
		for index in 0..<makersCulled.count {
			// make maker node
			
			let sphereGeometry = SCNSphere(radius: makerSphereRadius)
			sphereGeometry.firstMaterial!.diffuse.contents = UIColor.black
			let makerNode = SCNNode(geometry: sphereGeometry)
			makerNode.opacity = 0.0 // start transparent
			makerNode.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
			rootNode.addChildNode(makerNode)
			makerNodes.append(makerNode)

			// find the shadow colors through the palettes relationship
			// we know there are palettes because we filtered out the ones without
			
			for palette in makersCulled[index].eyePalettes! {
				for shadow in (palette as! EyePalette).shadows! {
					attachColorToMaker(shadow as! ShadowColor, makerNode: makerNode)
				}
			}
			
		}

		let shadowFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ShadowColor")
		
		do {
			self.shadowColors = try moc.fetch(shadowFetchRequest) as! [ShadowColor]
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}

		rotateSphere() // Attach the animation to the node to start it.
		
		scheduleMakerAnimations()
	}

	// TODO: required initializer that should be fleshed out
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func attachColorToMaker(_ shadowColor: ShadowColor, makerNode: SCNNode) {

		// calculate geometry and position
		let sphereGeometry = SCNSphere(radius: littleSphereRadius)

		// add color
		
		sphereGeometry.firstMaterial!.diffuse.contents = UIColor.init(hue: CGFloat(shadowColor.hue), saturation: CGFloat(shadowColor.saturation), brightness: CGFloat(shadowColor.brightness), alpha: 1.0)
		sphereGeometry.firstMaterial!.lightingModel = .phong // TODO: pretty sure Phong isn't the right answer, but it's a first approximation
		
		// add geometry to sphere

		let sphereNode = SCNNode(geometry: sphereGeometry)
		sphereNode.position = calcPosition(shadowColor)
		
		// add to maker SCNNode
		
		makerNode.addChildNode(sphereNode)
	}
	
	func calcPosition(_ shadowColor: ShadowColor) -> SCNVector3 {

		// precalculated when color was added to CoreData, but that could change if desired
		
		let vector = SCNVector3(x: Float(shadowColor.x), y: Float(shadowColor.y), z: Float(shadowColor.z))
		
		return vector
	}
	
	
	// MARK: Animation-fu

	
//	var animateMakerNode: CABasicAnimation  = {
//		let twinkleAnimation = CABasicAnimation(keyPath: "opacity")
//		twinkleAnimation.fromValue =  0.0
//		twinkleAnimation.toValue =  1.0
//		twinkleAnimation.duration = 10.0
//		twinkleAnimation.autoreverses = true
//
//
//		return twinkleAnimation
//	}()
	
	func setMakerTitle() {
		
	}
	
	func animateMakerNode(makerNode: SCNNode, index: Int) {
		
//		makerNode.runAction(SCNAction.sequence(
//			[SCNAction.wait(duration: makerAnimationDuration * Double(index)),
//			 SCNAction.run({ (node) in
//
//				self.vc!.setMakerName(self.makerNameArray[index])
//				print(self.makerNameArray[index])
//
////				mnn.setString(text: self.makerNameArray[index])
//			}),
//			 SCNAction.fadeIn(duration: makerAnimationDuration/4.0),
//			 SCNAction.wait(duration: makerAnimationDuration/2.0),
//			 SCNAction.fadeOut(duration: makerAnimationDuration/4.0),
//			 ]))
		
		let _ = SCNTransaction()
		makerNode.runAction(SCNAction.wait(duration: makerAnimationDuration * Double(index)))
		textGeometry.string = makersCulled[index].name
//		vc!.setMakerName(self.makerNameArray[index])
//		print(self.makerNameArray[index])
		makerNode.runAction(SCNAction.sequence([SCNAction.fadeIn(duration: makerAnimationDuration/4.0),
					SCNAction.wait(duration: makerAnimationDuration/2.0),
					SCNAction.fadeOut(duration: makerAnimationDuration/4.0),
					]))
		
//		makerNameNode.runAction(SCNAction.sequence(
//			[SCNAction.wait(duration: makerAnimationDuration * Double(index)),
//			 SCNAction.run({ (node) in
//
//				let mnn = node as! MakerNameNode
//
//				mnn.setString(text: self.makerNameArray[index])
//			}),
//			 SCNAction.fadeIn(duration: makerAnimationDuration/4.0),
//			 SCNAction.wait(duration: makerAnimationDuration/2.0),
//			 SCNAction.fadeOut(duration: makerAnimationDuration/4.0),
//			 ]))
		

//		vc?.setMakerName(makerNameArray[index])
		
	}


	func scheduleMakerAnimations() {

		for index in 0..<makersCulled.count {

//			let makerName = makers[index].name

			let twinkleNode = makerNodes[index]
			
//			animateMakerNode(makerNode: twinkleNode, index: index)

			twinkleNode.runAction(SCNAction.sequence(
				[SCNAction.wait(duration: makerAnimationDuration * Double(index)),
				 SCNAction.run({ (node) in
		
						let makerName = self.makersCulled[index].name
		
						self.makerNameNode.setString(text: makerName)
					}),

				 SCNAction.fadeIn(duration: makerAnimationDuration/4.0),
				 SCNAction.wait(duration: makerAnimationDuration/2.0),
				 SCNAction.fadeOut(duration: makerAnimationDuration/4.0),
				 ]))

			twinkleNode.runAction(SCNAction.sequence(
				[SCNAction.wait(duration: makerAnimationDuration * Double(index)),

				 SCNAction.fadeIn(duration: makerAnimationDuration/4.0),
				 SCNAction.wait(duration: makerAnimationDuration/2.0),
				 SCNAction.fadeOut(duration: makerAnimationDuration/4.0),
				 ]))

//			SCNTransaction.easeInOut(duration: makerAnimationDuration) {
//				rootNode?.addChildNode(twinkleNode) // plug it in
//				twinkleNode.opacity = 1.0
//				twinkleNode.removeFromParentNode()	// unplug when we're done
///			}

			// Animate one complete revolution around the node's Y axis.

//			twinkleAnimation.fromValue =  0.05
//			twinkleAnimation.toValue =  1.0
//			twinkleAnimation.duration = makerAnimationDuration // take two whole seconds
//			twinkleAnimation.autoreverses = true
//
//			twinkleNode.layer.add(twinkleAnimation, forKey: "opacity-\(makerName)")
//			twinkleNode.layer.opacity = 0.0
//
//			twinkleArray.append(twinkleAnimation)
		}
//		twinkleAnimationGroup.repeatCount = .greatestFiniteMagnitude // Repeat the animation forever.
//
//		twinkleAnimationGroup.animations = twinkleArray

	}

	fileprivate func rotateSphere() {
		// rotate the root node
		
		let action = SCNAction.repeatForever(SCNAction.rotate(by: -1*(.pi), around: SCNVector3(0, 1, 0), duration: makerAnimationDuration))
		rootNode.runAction(action)
	}
}

