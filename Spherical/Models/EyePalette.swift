//
//  EyePalette.swift
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

public class EyePalette: NSManagedObject {
	
	@NSManaged public var boughtFrom: String?
	@NSManaged public var boughtOn: Date?
	@NSManaged public var name: String
	@NSManaged public var pricePaid: NSDecimalNumber?
	@NSManaged public var rating: Int16
	@NSManaged public var predictedRating: Double
	@NSManaged public var maker: Maker?
	@NSManaged public var shadows: NSSet?
	@NSManaged public var uuid: String
	
	// Not setting UUID in this app because this data repository is read only at this time.
	// TODO: Integrate Ensembles so that it can be read/write.
	
//	func setUniqueidentifier(_ uniqueidentifier: String) {
//		self.uniqueidentifier = uniqueidentifier
//	}
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<EyePalette> {
		return NSFetchRequest<EyePalette>(entityName: "EyePalette")
	}

	public lazy var moc: NSManagedObjectContext = {
		return self.storeContainer.viewContext
	}()
	
	public lazy var storeContainer: NSPersistentContainer = {
		
		let container = NSPersistentContainer(name: "Colors_0.06")
		container.loadPersistentStores { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()
	
	func sortedShadows() -> [ShadowColor] {
		let sortByPosition = NSSortDescriptor.init(key: "position", ascending: true)
		let sortByName = NSSortDescriptor.init(key: "name", ascending: true)

		return (self.shadows)?.sortedArray(using: [sortByPosition, sortByName]) as! [ShadowColor]
	}
	
	func shadowByPositionAndName(shadowPosition: Int, shadowName: String) -> ShadowColor? {
		
		let appDelegate = UIApplication.shared.delegate as? AppDelegate

		let positionPredicate = NSPredicate(format: "position = %@", shadowPosition )
		let namePredicate = NSPredicate(format: "name =[cd] %@", shadowName )
		let palettePredicate = NSPredicate(format: "palette = %@", self )
		
		var colors : [ShadowColor] = []

		let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [positionPredicate, namePredicate, palettePredicate])
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShadowColor")
		fetchRequest.predicate = compoundPredicate
		
		let moc = appDelegate?.persistentContainer.viewContext
		
		do {
			colors = try moc?.fetch(fetchRequest) as! [ShadowColor]
			
		} catch let err as NSError {
			print("Could not fetch \(err), \(err.userInfo)")
		}

		return colors.first ?? nil
	}
	
	@objc(addShadowsObject:)
	@NSManaged public func addToShadows(_ value: ShadowColor)
	
	@objc(removeShadowsObject:)
	@NSManaged public func removeFromShadows(_ value: ShadowColor)
	
	@objc(addShadows:)
	@NSManaged public func addToShadows(_ values: NSSet)
	
	@objc(removeShadows:)
	@NSManaged public func removeFromShadows(_ values: NSSet)

}
