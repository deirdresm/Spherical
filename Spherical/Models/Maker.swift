//
//  Maker.swift
//  ColorSphere
//
//  Created by Deirdre Saoirse Moen on 10/10/18.
//  Copyright © 2018 Deirdre Saoirse Moen. All rights reserved.
//

import Foundation
import RealmSwift

class Maker : Object {
	
	@objc dynamic var id = 0
	@objc dynamic var name = ""
	
	let palettes = List<Palette>()
	
	override class func primaryKey() -> String? {
		return "id"
	}
	
	class func getNextID() -> Int {
		let realm = try! Realm()
		return (realm.objects(Maker.self).max(ofProperty: "id") as Int? ?? 0) + 1
	}
	
}
