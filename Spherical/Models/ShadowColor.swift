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

enum ShadowColorSort {
	case none
	case name
	case makerPaletteName
}

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
	
	
	// Not setting UUID in this app because this data repository is read only at this time.
	// TODO: Integrate Ensembles so that it can be read/write.
	
	//	func setUniqueidentifier(_ uniqueidentifier: String) {
	//		self.uniqueidentifier = uniqueidentifier
	//	}

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
		
		let π = Double.pi

		let sRadians = 2.0 * self.hue * π
		let tRadians = self.brightness * π

		self.x = radius * cos(sRadians) * sin(tRadians)
		self.y = radius * cos(tRadians)
		self.z = radius * sin(sRadians) * sin(tRadians)

	}
	
	/* check if the various color parameters look real (or if this is a broken color) */
	
	func colorLooksGood() -> Bool {
		
		let ε = 0.000125 // avoid double/float comparison rounding errors
		
		if isCalibrated == true {
			return true
		}
		
		// ratings technically go from 1 to 10, but they can be zero if never initialized.
		
		if predictedRating < ε || predictedRating > 10.0 - ε {
			return false
		}
		
		// either the hue is 0 or 1 OR the saturation and brightness is 0 Or 1.
		
		if (self.hue < ε || self.hue > 1.0 - ε) ||
			((self.saturation < ε || self.saturation > 1.0 - ε) &&
			 (self.brightness < ε || self.brightness > 1.0 - ε)) {
			
			return false // didn't parse correctly the first time. Probably.
		}
		
		return true // TODO: I think, must ponder more
		
	}
	
	// class methods
	
}
