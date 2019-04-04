//
//  Maker+CoreDataClass.swift
//  
//
//  Created by Deirdre Saoirse Moen on 11/30/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


public class Maker: NSManagedObject {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Maker> {
		return NSFetchRequest<Maker>(entityName: "Maker")
	}
	
	@NSManaged public var name: String
	@NSManaged public var predictedRating: Double
	@NSManaged public var eyePalettes: NSSet?
	@NSManaged public var uuid: String
	
	// Not setting UUID in this app because this data repository is read only at this time.
	// TODO: Integrate Ensembles so that it can be read/write.
	
//	func setUniqueidentifier(_ uniqueidentifier: String) {
//		self.uniqueidentifier = uniqueidentifier
//	}
	
	func numShadowColors() -> Int {
		var shadowCount = 0
		
		for palette in eyePalettes! {
			shadowCount += (palette as! EyePalette).shadows?.count ?? 0
		}
		return shadowCount
	}

	func shadowsByPaletteOrderName() -> NSMutableArray? {
		
		let palettes = sortedPalettes()
		let shadows = (NSMutableArray())
		
		for palette in palettes {
			shadows.addObjects(from: palette.sortedShadows())
		}
		
		return shadows
	}
	
	
	// palettes for current maker in alphabetical order
	
	func sortedPalettes() -> [EyePalette] {
		let sortNameDescriptor = NSSortDescriptor.init(key: "name", ascending: true)
		
		return (self.eyePalettes)?.sortedArray(using: [sortNameDescriptor]) as! [EyePalette]
	}
	
	@objc(addEyePalettesObject:)
	@NSManaged public func addToEyePalettes(_ value: EyePalette)
	
	@objc(removeEyePalettesObject:)
	@NSManaged public func removeFromEyePalettes(_ value: EyePalette)
	
	@objc(addEyePalettes:)
	@NSManaged public func addToEyePalettes(_ values: NSSet)
	
	@objc(removeEyePalettes:)
	@NSManaged public func removeFromEyePalettes(_ values: NSSet)
}
