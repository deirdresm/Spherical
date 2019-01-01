//
//  EyePalette+CoreDataClass.swift
//  
//
//  Created by Deirdre Saoirse Moen on 11/30/18.
//
//  This file was automatically generated and should not be edited.
//

import UIKit
import CoreData

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
}
