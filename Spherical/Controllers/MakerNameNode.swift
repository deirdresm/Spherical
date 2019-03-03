//
//  MakerNameNode.swift
//  Spherical
//
//  Created by Deirdre Saoirse Moen on 2/19/19.
//  Copyright © 2019 Deirdre Saoirse Moen. All rights reserved.
//

import UIKit
import SceneKit

class MakerNameNode: SCNNode {
	
	convenience init(makerName: String) {
		self.init()
		
		let constraints = SCNBillboardConstraint()
		let node = SCNNode()
		let extrusionDepth : CGFloat = 0.002
		let makerNameScale = SCNVector3Make(0.2, 0.2, 0.2)
		self.position = SCNVector3(x: 0, y: 1.5, z: 0)

		let max, min: SCNVector3
		let tx, ty, tz: Float

		geometry = SCNText(string: makerName, extrusionDepth: extrusionDepth)
		geometry?.firstMaterial?.diffuse.contents = UIColor.white
		geometry?.firstMaterial?.specular.contents = UIColor.white
		
		max = geometry!.boundingBox.max
		min = geometry!.boundingBox.min

		tx = (max.x - min.x)/2
		ty = min.y
		tz = Float(extrusionDepth)/2
		
		node.scale = makerNameScale
		self.center()
		
		self.addChildNode(node)
		self.constraints = [constraints]

	}
	
	func setString(text: String) {
		
		(geometry as! SCNText).string = text
		
	}
	
	func center() {
		let (min, max) = self.boundingBox
		
		let dx = min.x + 0.5 * (max.x - min.x)
		let dy = Float(2.0) // min.y + 0.5 * (max.y - min.y)
		let dz = Float(1.0) // min.z + 0.5 * (max.z - min.z)
		self.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
	}


}
