//
//  ViewController.swift
//  Spherical
//
//  Created by Deirdre Saoirse Moen on 10/25/18.
//  Copyright © 2018 Deirdre Saoirse Moen. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
	
	@IBOutlet var scnView: SCNView!
	
	@IBOutlet weak var makerNameLabel: UILabel!
	
	fileprivate func setupScene() {
		// Do any additional setup after loading the view, typically from a nib.
		
		scnView.backgroundColor = UIColor.black
		
		scnView.autoenablesDefaultLighting = true
		scnView.allowsCameraControl = true
		
		// add scene-based lighting
		
		let keyLight = SCNLight()
		let keyLightNode = SCNNode()
		let ambientLight = SCNLight()
		let ambientLightNode = SCNNode()
		let cameraNode = SCNNode()          // the camera
		
		cameraNode.camera = SCNCamera()
		cameraNode.position = SCNVector3Make(0, 0, 12)
		
		keyLight.type = SCNLight.LightType.omni
		keyLightNode.light = keyLight
		keyLightNode.position = SCNVector3(x: 7, y: 7, z: 5)
		
		keyLightNode.constraints = []
		cameraNode.addChildNode(keyLightNode)
		
		ambientLight.type = SCNLight.LightType.ambient
		
		let shade: CGFloat = 0.40
		ambientLight.color = UIColor(red: shade, green: shade, blue: shade, alpha: 1.0)
		ambientLightNode.light = ambientLight
		cameraNode.addChildNode(ambientLightNode)
		scnView.pointOfView?.addChildNode(cameraNode)
		
		// add gesture recognizers here
		
		// add colors (from database) to the scene
		scnView.scene = PrimitivesScene()
		
		// TODO: fugly
		(scnView!.scene! as! PrimitivesScene).vc = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupScene()

	}
	
	func setMakerName(_ name: String) {
		makerNameLabel.text = name
	}

	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
}

