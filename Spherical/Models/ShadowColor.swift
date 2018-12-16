//
//  ShadowColor.swift
//  ColorSphere
//
//  Created by Deirdre Saoirse Moen on 10/10/18.
//  Copyright © 2018 Deirdre Saoirse Moen. All rights reserved.
//

//import Foundation
//import RealmSwift
//
//enum ShadowTexture {
//	case matte, satin, shimmer, duochrome, glitter
//}
//
//class ShadowColor : Object {
//	@objc dynamic var id = 0
//	@objc dynamic var name = ""
//	
//	@objc dynamic var position = 0 // in palette
//	@objc dynamic var filename : String = ""
//	
//	@objc dynamic var hue : Double = 0.0
//	@objc dynamic var saturation : Double = 0.0
//	@objc dynamic var brightness : Double = 0.0
//	
//	@objc dynamic var x : Double = 0.0
//	@objc dynamic var y : Double = 0.0
//	@objc dynamic var z : Double = 0.0
//	
//	@objc dynamic var finish : String = ""
//	
//	//	@objc dynamic var texture : Int = 0 // will hook up to ShadowTexture later
//	
//	@objc dynamic var palette: Palette?
//	
//	override class func primaryKey() -> String? {
//		return "id"
//	}
//	
//	class func getNextID() -> Int {
//		let realm = try! Realm()
//		return (realm.objects(ShadowColor.self).max(ofProperty: "id") as Int? ?? 0) + 1
//	}
//	
//	func xyz() {
//		
//		let radius = self.saturation
//		
//		let sRadians = 360.0 * self.hue * Double.pi / 180.0
//		let tRadians = 180.0 * (self.brightness * Double.pi) / 180.0
//		
//		self.x = radius * cos(sRadians) * sin(tRadians)
//		self.y = radius * cos(tRadians)
//		self.z = radius * sin(sRadians) * sin(tRadians)
//		
//	}
//	
//	func set(palette: Palette, name: String, position: Int, hue: Double, saturation: Double, brightness: Double, finish: String) {
//		
//		self.name = name
//		self.position = position
//		self.hue = hue
//		self.saturation = saturation
//		self.brightness = brightness
//		self.finish = finish
//		xyz()
//		
//		palette.colors.append(self)
//	}
//}
