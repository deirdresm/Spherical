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
	
	var scnScene: SCNScene?
	
	@IBOutlet var scnView: SCNView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		scnView.backgroundColor = UIColor.black
		
		scnView.autoenablesDefaultLighting = true
		scnView.allowsCameraControl = true
		
		print("about to initialize primitives")
		scnView.scene = PrimitivesScene()
	}

}

