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

class TestPersistentContainer : XCTestCase {
	
	let modelURL = Bundle.main.url(forResource: "NestedToDoListSwift", withExtension:"momd")
	
	public lazy var storeURL : URL = {
		
		let storeDir = FileManager.default.temporaryDirectory.appendingPathComponent("nestedToDoTest.sqlite")
		
		return storeDir
		
	}()
	
	var container : NSPersistentContainer!

	override func setUp() {
		copyDataStoreToTemp() // copy db files over from bundle
		
		container = NSPersistentContainer.testContainer()
		
	}
	
	override func tearDown() {
		
	}
	
	func copyDataStoreToTemp() {
		let tempStoreDir = storeURL
		let shmFileURL = URL(fileURLWithPath: tempStoreDir.absoluteString + "-shm")
		let walFileURL = URL(fileURLWithPath: tempStoreDir.absoluteString + "-wal")

		let projectStoreURL = Bundle.main.url(forResource: "Colors_0.06", withExtension:"sqlite")
		let shmProjURL = URL(fileURLWithPath: (projectStoreURL?.absoluteString)! + "-shm")
		let walProjURL = URL(fileURLWithPath: (projectStoreURL?.absoluteString)! + "-wal")

		if FileManager.default.fileExists(atPath: tempStoreDir.absoluteString) {
			try! FileManager.default.removeItem(at: tempStoreDir)
			try! FileManager.default.removeItem(at: shmFileURL)
			try! FileManager.default.removeItem(at: walFileURL)
		}
		
		try! FileManager.default.copyItem(at: projectStoreURL!, to: tempStoreDir)
		try! FileManager.default.copyItem(at: shmProjURL, to: shmFileURL)
		try! FileManager.default.copyItem(at: walProjURL, to: walFileURL)

	}
	
	func testPersistentContainer() {
		XCTAssertNotNil(self.container, "SHould have a persistent container")

		XCTAssertNotNil(self.container.viewContext, "SHould have a managed object context")
		XCTAssertNotNil(self.container.viewContext, "SHould have a persistent stack")
		
		let store : NSPersistentStore = (self.container.viewContext.persistentStoreCoordinator?.persistentStores.first)!
		
		XCTAssertNotNil(store, "SHould have a persistent store")
		XCTAssertEqual(store.type, NSSQLiteStoreType, "Should be a sqlite store");
		XCTAssertNotNil(self.container.viewContext.undoManager, "Should have an undo manager");
	}

}
