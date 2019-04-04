import Foundation
import SceneKit

// from: https://github.com/roberthein/Extras/blob/14ce56ebbe458a5602409adee40f8a66ff79d601/Extras/Classes/Extensions/SceneKit/SCNTransaction.swift

public extension SCNTransaction {
	
	typealias TransactionClosure = (() -> ())
	
	/// A simple ease in animation with SCNTransaction.
	///
	/// - Parameters:
	///   - duration: The TimeInterval representing the duration of the animation
	///   - transaction: The animation closure
	static func easeIn(duration: TimeInterval, _ animation: () -> (), _ completionBlock: @escaping TransactionClosure) {
		SCNTransaction.begin()
		SCNTransaction.animationDuration = duration
		SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
		SCNTransaction.completionBlock = completionBlock
		animation()
		SCNTransaction.commit()
	}
	
	/// A simple ease out animation with SCNTransaction.
	///
	/// - Parameters:
	///   - duration: The TimeInterval representing the duration of the animation
	///   - transaction: The animation closure
	static func easeOut(duration: TimeInterval, _ animation: () -> (), _ completionBlock: @escaping TransactionClosure) {
		SCNTransaction.begin()
		SCNTransaction.animationDuration = duration
		SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
		SCNTransaction.completionBlock = completionBlock
		animation()
		SCNTransaction.commit()
	}
	
	/// A simple ease in and out animation with SCNTransaction.
	///
	/// - Parameters:
	///   - duration: The TimeInterval representing the duration of the animation
	///   - transaction: The animation closure
	static func easeInOut(duration: TimeInterval, _ transaction: () -> ()) {
		SCNTransaction.begin()
		SCNTransaction.animationDuration = duration
		SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		transaction()
		SCNTransaction.commit()
	}
	
}
