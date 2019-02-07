//
//  SphereScnNode.swift
//  Spherical
//
//  Created by Deirdre Saoirse Moen on 1/22/19.
//  Copyright © 2019 Deirdre Saoirse Moen. All rights reserved.
//

import UIKit
import SceneKit

class SphereScnNode: SCNNode {
	
	let layer = {
		return CALayer()
	}()
	
	override init() {
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init(geometry: SCNGeometry) {
		super.init()
		self.geometry = geometry
	}


}
