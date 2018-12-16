//
//  EyePalette+CoreDataClass.swift
//  
//
//  Created by Deirdre Saoirse Moen on 11/30/18.
//
//  This file was automatically generated and should not be edited.
//

import Cocoa
import CoreData
import AppKit

public class EyePalette: NSManagedObject {
	
	public lazy var moc: NSManagedObjectContext = {
		return self.storeContainer.viewContext
	}()
	
	public lazy var storeContainer: NSPersistentContainer = {
		
		let container = NSPersistentContainer(name: "Colors")
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
		
		let appDelegate = NSApplication.shared.delegate as? AppDelegate

		let positionPredicate = NSPredicate(format: "position = %@", shadowPosition )
		let namePredicate = NSPredicate(format: "name =[cd] %@", shadowName )
		let palettePredicate = NSPredicate(format: "palette = %@", self )
		
		var colors : [ShadowColor] = []

		let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [positionPredicate, namePredicate, palettePredicate])
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShadowColor")
		fetchRequest.predicate = compoundPredicate
		
		let moc = appDelegate?.container.viewContext
		
		do {
			colors = try moc?.fetch(fetchRequest) as! [ShadowColor]
			
		} catch let err as NSError {
			print("Could not fetch \(err), \(err.userInfo)")
		}

		return colors.first ?? nil
	}
}
