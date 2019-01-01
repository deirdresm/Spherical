//
//  ShadowColor+CoreDataProperties.swift
//  
//
//  Created by Deirdre Saoirse Moen on 11/30/18.
//
//  This file was automatically generated and should not be edited.
//

import UIKit
import CoreData


extension ShadowColor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShadowColor> {
        return NSFetchRequest<ShadowColor>(entityName: "ShadowColor")
    }

    @NSManaged public var boughtOn: Date?
    @NSManaged public var brightness: Double
    @NSManaged public var cropFile: URL?
    @NSManaged public var hue: Double
    @NSManaged public var imageFile: URL?
    @NSManaged public var lastWorn: Date?
    @NSManaged public var name: String
    @NSManaged public var position: Int16
    @NSManaged public var pricePaid: NSDecimalNumber?
    @NSManaged public var rating: Int16
	@NSManaged public var predictedRating: Double
	@NSManaged public var saturation: Double
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var z: Double
	@NSManaged public var nsColor: UIColor
    @NSManaged public var eyePalette: EyePalette?

}
