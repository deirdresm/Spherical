//
//  ShadowColor.swift
//  ColorSphere
//
//  Created by Deirdre Saoirse Moen on 10/10/18.
//  Copyright © 2018 Deirdre Saoirse Moen. All rights reserved.
//

import Foundation
import RealmSwift

enum ShadowTexture {
	case matte, satin, shimmer, duochrome, glitter
}

class ShadowColor : Object {
	@objc dynamic var id = 0
	@objc dynamic var name = ""
	@objc dynamic var photoLoc : String = ""
	@objc dynamic var position = 0
	@objc dynamic var hue : Double = 0.0
	@objc dynamic var saturation : Double = 0.0
	@objc dynamic var brightness : Double = 0.0
	@objc dynamic var finish : String = ""
	@objc dynamic var photoFileName : String = ""
	
	//	@objc dynamic var texture : Int = 0 // will hook up to ShadowTexture later
	
	@objc dynamic var palette: Palette?
	
	override class func primaryKey() -> String? {
		return "id"
	}
	
	class func getNextID() -> Int {
		let realm = try! Realm()
		return (realm.objects(ShadowColor.self).max(ofProperty: "id") as Int? ?? 0) + 1
	}
	
	func set(palette: Palette, name: String, position: Int, hue: Double, saturation: Double, brightness: Double, finish: String) {
		
		self.name = name
		self.position = position
		self.hue = hue
		self.saturation = saturation
		self.brightness = brightness
		self.finish = finish
		
		palette.colors.append(self)
	}
}
