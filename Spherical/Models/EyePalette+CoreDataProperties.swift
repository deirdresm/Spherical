//
//  EyePalette+CoreDataProperties.swift
//
//
//  Created by Deirdre Saoirse Moen on 11/30/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension EyePalette {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<EyePalette> {
		return NSFetchRequest<EyePalette>(entityName: "EyePalette")
	}
	
	@NSManaged public var boughtFrom: String?
	@NSManaged public var boughtOn: Date?
	@NSManaged public var name: String
	@NSManaged public var pricePaid: NSDecimalNumber?
	@NSManaged public var rating: Int16
	@NSManaged public var predictedRating: Double
	@NSManaged public var maker: Maker?
	@NSManaged public var shadows: NSSet?
	
}

// MARK: Generated accessors for shadows
extension EyePalette {
	
	@objc(addShadowsObject:)
	@NSManaged public func addToShadows(_ value: ShadowColor)
	
	@objc(removeShadowsObject:)
	@NSManaged public func removeFromShadows(_ value: ShadowColor)
	
	@objc(addShadows:)
	@NSManaged public func addToShadows(_ values: NSSet)
	
	@objc(removeShadows:)
	@NSManaged public func removeFromShadows(_ values: NSSet)
	
}
