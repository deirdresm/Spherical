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
	
	private var makerNameText: SCNText?
	
	convenience init(makerName: String) {
		self.init()
		
		let constraints = SCNBillboardConstraint()
		let node = SCNNode()
		let extrusionDepth : CGFloat = 0.002
		let makerNameScale = SCNVector3Make(0.2, 0.2, 0.2)

		let max, min: SCNVector3
		let tx, ty, tz: Float

		makerNameText = SCNText(string: makerName, extrusionDepth: extrusionDepth)
		makerNameText?.firstMaterial?.diffuse.contents = UIColor.white
		makerNameText?.firstMaterial?.specular.contents = UIColor.white
		
		max = makerNameText!.boundingBox.max
		min = makerNameText!.boundingBox.min

		tx = (max.x - min.x)/2
		ty = min.y
		tz = Float(extrusionDepth)/2
		
		node.geometry = makerNameText
		node.scale = makerNameScale
		self.center()
		
		self.addChildNode(node)
		self.constraints = [constraints]

	}
	
	func setString(text: String) {
		
		makerNameText?.string = text
		
	}
	
	func center() {
		let (min, max) = self.boundingBox
		
		let dx = min.x + 0.5 * (max.x - min.x)
		let dy = min.y + 0.5 * (max.y - min.y)
		let dz = min.z + 0.5 * (max.z - min.z)
		self.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
	}


}
