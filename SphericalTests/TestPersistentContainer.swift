//
//  TestPersistentContainer.swift
//  SphericalTests
//
//  Created by Deirdre Saoirse Moen on 1/23/19.
//  Copyright © 2019 Deirdre Saoirse Moen. All rights reserved.
//

import XCTest
import Foundation
import CoreData

extension NSPersistentContainer {
	
	class func testContainer() -> NSPersistentContainer {
		let container = NSPersistentContainer(name: "Colors_0.06")
		
		let persistentStoreDescription = NSPersistentStoreDescription()
		persistentStoreDescription.type = NSInMemoryStoreType
		
		container.persistentStoreDescriptions = [persistentStoreDescription]
		container.loadPersistentStores { (description, error) in
			print(description)
			if let error = error {
				fatalError("\(error)")
			}
		}
		container.viewContext.automaticallyMergesChangesFromParent = true
		return container
	}

}
