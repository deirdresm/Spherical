//
//  JSONcolors.swift
//  Spherical
//
//  Created by Deirdre Saoirse Moen on 10/27/18.
//  Copyright © 2018 Deirdre Saoirse Moen. All rights reserved.
//

// Note: the export was working before I hacked and slashed at it, but the import was an issue, so
// I stopped using it for this project. Here as vestigial, basically.

import Foundation

struct JSONcolors: Codable {
	var name: String
	var palette_id: Int = 0
	var position : Int = 0
	var hue : Double = 0.0
	var saturation : Double = 0.0
	var brightness : Double = 0.0
	
	init(name: String, palette_id: Int, position: Int, hue: Double, saturation: Double, brightness: Double) {
		self.name = name
		self.palette_id = palette_id
		self.position = position
		self.hue = hue
		self.saturation = saturation
		self.brightness = brightness
	}
	
	static func readEntries() -> [JSONcolors] {
//		var manager = FileManager()
		
		let fileURL = Bundle.main.path(forResource: "shadow-export", ofType: "json")
		var entries : [JSONcolors] = []

		var jsonStr = ""
		
		do {
			jsonStr = try String(contentsOfFile: fileURL!, encoding: String.Encoding.utf8)
		} catch let error as NSError {
			print("Failed reading from URL: \(String(describing: fileURL)), Error: " + error.localizedDescription)
		}

/*		let userDir = try! manager.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		
		let jsonURL = userDir.appendingPathComponent("shadow-export.json")
		if !manager.fileExists(atPath: jsonURL.path) {
			return [] // don't error out, just return an empty array (we'll create on save)
		}
		
		if let jsonData = manager.contents(atPath: jsonURL.path) {
*/
		let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
		
			let jsonData = Data(base64Encoded: jsonStr)
			
			do {
				entries = try decoder.decode([JSONcolors].self, from: jsonData!)
				return entries
			} catch {
				fatalError("Can't decode existing saved file")
			}
//		}
		return entries
	}
}
