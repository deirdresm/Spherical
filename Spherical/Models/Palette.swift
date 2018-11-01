//
//  Palette.swift
//  ColorSphere
//
//  Created by Deirdre Saoirse Moen on 10/10/18.
//  Copyright © 2018 Deirdre Saoirse Moen. All rights reserved.
//

import Foundation
import RealmSwift

class Palette : Object {
	@objc dynamic var id = 0
	@objc dynamic var name = ""
	@objc dynamic var boughtOn = Date()
	@objc dynamic var purchasedFrom = ""
	@objc dynamic var size = "M"
	@objc dynamic var lastWornOn = Date()
	
	@objc dynamic var maker: Maker?
	@objc dynamic var storageLoc: StorageLoc?
	let colors = List<ShadowColor>()
	
	override class func primaryKey() -> String? {
		return "id"
	}
	
	class func getNextID() -> Int {
		let realm = try! Realm()
		return (realm.objects(Palette.self).max(ofProperty: "id") as Int? ?? 0) + 1
	}
	
	override var description: String {
		
		let thisMaker = self.maker as! Maker
		return "\(thisMaker.name) \(name)"
	}
	
	func set(maker: Maker, name: String) {
		
		self.name = name
		
		maker.palettes.append(self)
	}
}
