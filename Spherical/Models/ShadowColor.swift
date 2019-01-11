//
//  ShadowColor+CoreDataClass.swift
//  
//
//  Created by Deirdre Saoirse Moen on 11/30/18.
//
//  This file was automatically generated and should not be edited.
//

#if os(iOS)
import UIKit
#endif

#if os(macOS)
import Cocoa
#endif

import CoreData
import CoreML
import Vision

public class ShadowColor: NSManagedObject {

	@NSManaged public var name: String
	@NSManaged public var position: Int16 // position in palette; -1 if not in a palette

	@NSManaged public var predictedRating: Double // CoreML fun

	@NSManaged public var hue: Double
	@NSManaged public var saturation: Double
	@NSManaged public var brightness: Double
	@NSManaged public var nsColor: UIColor

	@NSManaged public var imageFile: URL?
	@NSManaged public var imageFileSize: Int64
	@NSManaged public var imageParsedAt: Date?

	@NSManaged public var cropFile: URL?
	@NSManaged public var cropFileSize: Int64
	@NSManaged public var cropParsedAt: Date?

	@NSManaged public var eyePalette: EyePalette?
	@NSManaged public var isCalibrated: Bool
	@NSManaged public var uuid: String

	@NSManaged public var x: Double
	@NSManaged public var y: Double
	@NSManaged public var z: Double

	// following are manually entered and not calculated using ImportImages
	
	@NSManaged public var lastWorn: Date?
	@NSManaged public var boughtOn: Date?
	@NSManaged public var pricePaid: NSDecimalNumber?
	@NSManaged public var rating: Int16
	@NSManaged public var temptaliaRating: Int16
	
	
	/* print the name of the maker, palette, and shadow */
	
	func fullName() -> String {
		let p = self.eyePalette
		let m = p?.maker
		
		return("\(m!.name): \(p!.name), \(self.name)")
	}

	/* pre-calculate position on a sphere */
	
	func xyz() {

		let bigSphereRadius : CGFloat = 2.0 // radius

		let radius = Double(bigSphereRadius) + (1.25 * self.saturation) - 0.5

		let sRadians = 2.0 * self.hue * Double.pi
		let tRadians = self.brightness * Double.pi

		self.x = radius * cos(sRadians) * sin(tRadians)
		self.y = radius * cos(tRadians)
		self.z = radius * sin(sRadians) * sin(tRadians)

	}
	
	/* check if the various color parameters look real (or if this is a broken color) */
	
	func colorLooksGood() -> Bool {
		
		let epsilon = 0.0025 // avoid double/float comparison rounding errors
		
		if isCalibrated == true {
			return true
		}
		
		// ratings technically go from 1 to 10, but they can be zero if never initialized.
		
		if predictedRating < epsilon || predictedRating > 10.0 - epsilon {
			return false
		}
		
		// either the hue is 0 or 1 OR the saturation and brightness is 0 Or 1.
		
		if (self.hue < epsilon || self.hue > 1.0 - epsilon) ||
			((self.saturation < epsilon || self.saturation > 1.0 - epsilon) &&
			 (self.brightness < epsilon || self.brightness > 1.0 - epsilon)) {
			
			return false // didn't parse correctly the first time. Probably.
		}
		
		return true // TODO: I think, must ponder more
		
	}
	
	func predictFavorites(image: CIImage) {	// cropped image file
		
		let model = DeirdreFaveColors()
		
		if let cgImage = ImageProcessor.convertCIImageToCGImage(inputImage: image) {
			if let pixBuf = ImageProcessor.pixelBuffer(forImage: cgImage) {
				guard let results = try? model.prediction(image: pixBuf) else {fatalError("Unexpected runtime error")}
				
				self.predictedRating = 10.0 * (results.classLabelProbs["Love"] ?? 0.0)
				self.predictedRating += 5.0 * (results.classLabelProbs["Like"] ?? 0.0)
				self.predictedRating += 1.0 * (results.classLabelProbs["Dislike"] ?? 0.0)
			}
		}
				
	}

	func sortHSVbyMaker(_ maker : Maker) {
		
	}
	
	func sortByPaletteAndPosition(_ maker : Maker) {
		
	}

}
