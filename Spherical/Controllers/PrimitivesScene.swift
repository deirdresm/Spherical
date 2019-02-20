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
	
	var makerDict : NSMutableDictionary = [:]
	var makerNameArray : [String] = []
	var currentMaker = 0
	
	override init() {
		super.init()
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		
		let moc = appDelegate.persistentContainer.viewContext
		
		var makers: [Maker] = []
		
		let makerFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Maker")
		let nameSort = NSSortDescriptor(key: "name", ascending: true)
		makerFetchRequest.sortDescriptors = [nameSort]
		
		do {
			makers = try moc.fetch(makerFetchRequest) as! [Maker]
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
		
		for maker in makers {
			if maker.numShadowColors() < 20 {
				continue // not worth bothering with
			}
			
			// make maker node
			
			let sphereGeometry = SCNSphere(radius: makerSphereRadius)
			sphereGeometry.firstMaterial!.diffuse.contents = UIColor.black
			let makerNode = SphereScnNode(geometry: sphereGeometry)
			makerNode.opacity = 0.0 // start transparent
			makerNode.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
			rootNode.addChildNode(makerNode)
			makerDict[maker.name] = makerNode
			makerNameArray.append(maker.name)

			// find the shadow colors through the palettes relationship
			// we know there are palettes because we filtered out the ones without
			
			for palette in maker.eyePalettes! {
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

		let sphereNode = SphereScnNode(geometry: sphereGeometry)
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
	
	func animateMakerNode(makerNode: SCNNode, textNode: SCNText, index: Int) {
		
		makerNode.runAction(SCNAction.sequence(
			[SCNAction.wait(duration: makerAnimationDuration * Double(index)),
			 SCNAction.fadeIn(duration: makerAnimationDuration/4.0),
			 SCNAction.wait(duration: makerAnimationDuration/2.0),
			 SCNAction.fadeOut(duration: makerAnimationDuration/4.0),
			 ]))
		

//		vc?.setMakerName(makerNameArray[index])
		
	}


	func scheduleMakerAnimations() {
		
		for index in 0..<makerNameArray.count {
			
			let makerName = makerNameArray[index]
			
			let twinkleNode = makerDict[makerName] as! SphereScnNode
			
			let makerLabel = 
			
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

