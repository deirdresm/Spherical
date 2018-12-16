//
//  Maker+CoreDataClass.swift
//  
//
//  Created by Deirdre Saoirse Moen on 11/30/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


public class Maker: NSManagedObject {
	
	func shadowsByPaletteOrderName() -> NSMutableArray? {
		
		let palettes = sortedPalettes()
		var shadows = NSMutableArray()
		
		for palette in palettes {
			shadows.addObjects(from: palette.sortedShadows())
		}
		
		return shadows
	}
	
	func sortedPalettes() -> [EyePalette] {
		let sortNameDescriptor = NSSortDescriptor.init(key: "name", ascending: true)
		
		return (self.eyePalettes)?.sortedArray(using: [sortNameDescriptor]) as! [EyePalette]
	}

}
