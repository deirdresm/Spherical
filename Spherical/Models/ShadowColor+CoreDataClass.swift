//
//  ShadowColor+CoreDataClass.swift
//  
//
//  Created by Deirdre Saoirse Moen on 11/30/18.
//
//  This file was automatically generated and should not be edited.
//

import UIKit
import CoreData
import CoreML
import Vision

public class ShadowColor: NSManagedObject {

	func save() {
		// TODO: rewire save function
//		self.managedObjectContext.saveContext()
	}
	
	func xyz() {

		let bigSphereRadius : CGFloat = 2.0 // radius

		let radius = Double(bigSphereRadius) + (1.25 * self.saturation) - 0.5

		let sRadians = 2.0 * self.hue * Double.pi
		let tRadians = self.brightness * Double.pi

		self.x = radius * cos(sRadians) * sin(tRadians)
		self.y = radius * cos(tRadians)
		self.z = radius * sin(sRadians) * sin(tRadians)

	}
	
	func predictFavorites(image: CIImage) {	// cropped image file
		
		var colorPreference : Double = 0.0
		let model = DeirdreFaveColors()
		
		if let cgImage = ImageProcessor.convertCIImageToCGImage(inputImage: image) {
			if let pixBuf = ImageProcessor.pixelBuffer(forImage: cgImage) {
				guard let results = try? model.prediction(image: pixBuf) else {fatalError("Unexpected runtime error")}
				
				self.predictedRating = 10.0 * (results.classLabelProbs["Love"] ?? 0.0)
				self.predictedRating += 5.0 * (results.classLabelProbs["Like"] ?? 0.0)
				self.predictedRating += 1.0 * (results.classLabelProbs["Dislike"] ?? 0.0)
			}
		}
		
//		do {
//			let imageClassifier = try VNCoreMLModel(for: faveColors.model)
//
//			let classificationRequest = VNCoreMLRequest(model: imageClassifier, completionHandler: { (request, error) in
//				if let results = request.results as? [VNClassificationObservation] {
//					print("shadow \(self.name ?? String(23)): \(results.first!.identifier) : \(results.first!.confidence)")
//
//				}
//			})
//
//
//		} catch let error as NSError {
//			print("MLModel failed to load: \(error).")
//			self.predictedRating = -1.0
//		}
		
//		self.predictedRating = 0.0
		
	}

	func sortHSVbyMaker(_ maker : Maker) {
		
	}
	
	func sortByPaletteAndPosition(_ maker : Maker) {
		
	}
	
	func setPredictedValue() {
		
	}

}
