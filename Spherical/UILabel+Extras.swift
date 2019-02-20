// TODO: this may not be the right approach for text animation, but it's simpler than some alternatives.

////
////  UILabel+Extras.swift
////  Spherical
////
////  Created by Deirdre Saoirse Moen on 2/19/19.
////  Copyright © 2019 Deirdre Saoirse Moen. All rights reserved.
////
//
//import UIKit
//import SceneKit
//
//// Make UILabel SceneKit animatable, because reasons.
//
//extension UILabel: SCNAnimatable {
//	public func addAnimation(_ animation: SCNAnimationProtocol, forKey key: String?) {
//		
//	}
//	
//	public func addAnimationPlayer(_ player: SCNAnimationPlayer, forKey key: String?) {
//		let player = SCNAnimationPlayer(animation: anim)
//		self.addAnimationPlayer(player, forKey: key)
//	}
//	
//	public func removeAllAnimations() {
//		<#code#>
//	}
//	
//	public func removeAnimation(forKey key: String) {
//		<#code#>
//	}
//	
//	public var animationKeys: [String] {
//		<#code#>
//	}
//	
//	public func animationPlayer(forKey key: String) -> SCNAnimationPlayer? {
//		<#code#>
//	}
//	
//	public func removeAnimation(forKey key: String, blendOutDuration duration: CGFloat) {
//		<#code#>
//	}
//	
//	public func removeAnimation(forKey key: String, fadeOutDuration duration: CGFloat) {
//		<#code#>
//	}
//	
//	public func animation(forKey key: String) -> CAAnimation? {
//		<#code#>
//	}
//	
//	public func pauseAnimation(forKey key: String) {
//		<#code#>
//	}
//	
//	public func resumeAnimation(forKey key: String) {
//		<#code#>
//	}
//	
//	public func setAnimationSpeed(_ speed: CGFloat, forKey key: String) {
//		
//	}
//	
//	public func isAnimationPaused(forKey key: String) -> Bool {
//		<#code#>
//	}
//	
//}
