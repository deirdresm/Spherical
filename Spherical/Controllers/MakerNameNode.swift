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
		let makerNameScale = SCNVector3Make(0.01, 0.01, 0.001)
		self.position = SCNVector3(x: 0.5, y: 1.0, z: 1.0)

		let max: SCNVector3
		let min: SCNVector3
		
		let text = SCNText(string: makerName, extrusionDepth: extrusionDepth)
		let font = UIFont(name: "Helvetica", size: 15)
		text.font = font?.withSize(0.15)

		geometry = text
		geometry?.firstMaterial?.diffuse.contents = UIColor.white
		geometry?.firstMaterial?.specular.contents = UIColor.white
		

		max = geometry!.boundingBox.max
		min = geometry!.boundingBox.min

		node.scale = makerNameScale
		center()
		
		addChildNode(node)
		self.constraints = [constraints]

	}
	
	func setString(text: String) {
		
		(geometry as! SCNText).string = text
		center()
		
	}
	
	func center() {
		let (min, max) = self.boundingBox
		
		print("min, max = \(min), \(max)")
		
		let dx = min.x + 0.5 * (max.x - min.x)
		let dy = self.boundingBox.max.y
		let dz = Float(1.0) // min.z + 0.5 * (max.z - min.z)
		self.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
	}


}
