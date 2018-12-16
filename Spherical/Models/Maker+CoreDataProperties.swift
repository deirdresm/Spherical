//
//  Maker+CoreDataProperties.swift
//  
//
//  Created by Deirdre Saoirse Moen on 11/30/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Maker {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Maker> {
		return NSFetchRequest<Maker>(entityName: "Maker")
	}
	
	@NSManaged public var name: String
	@NSManaged public var predictedRating: Double
	@NSManaged public var eyePalettes: NSSet?
	
}

// MARK: Generated accessors for eyePalettes
extension Maker {
	
	@objc(addEyePalettesObject:)
	@NSManaged public func addToEyePalettes(_ value: EyePalette)
	
	@objc(removeEyePalettesObject:)
	@NSManaged public func removeFromEyePalettes(_ value: EyePalette)
	
	@objc(addEyePalettes:)
	@NSManaged public func addToEyePalettes(_ values: NSSet)
	
	@objc(removeEyePalettes:)
	@NSManaged public func removeFromEyePalettes(_ values: NSSet)
	
}

