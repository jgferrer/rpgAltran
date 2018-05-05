//
//  FavouritesUtils.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 5/5/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class FavouritesUtils {
    
    open class var shared: FavouritesUtils {
        struct Static {
            static let instance: FavouritesUtils = FavouritesUtils()
        }
        return Static.instance
    }
    
    open func addFavourite(name: String) {
        // --------------------------------------------------
        // Guardando / Actualizando en CoreData los Favoritos
        // --------------------------------------------------
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                // Actualizamos el campo arrayNames del item[0]
                let arrayData = NSKeyedArchiver.archivedData(withRootObject: ["Tobus Quickwhistle", "Libalia Chillgrill"])
                results![0].setValue(arrayData, forKey: "arrayNames")
            } else {
                // La primera vez hay que crear el item[0]
                let gnomes = NSEntityDescription.insertNewObject(forEntityName: "Favourites", into: context) as NSManagedObject
                let arrayData = NSKeyedArchiver.archivedData(withRootObject: ["Tobus Quickwhistle", "Libalia Chillgrill"])
                gnomes.setValue(arrayData, forKey: "arrayNames")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
        // ------------------------------------ //
    }
    
    open func getFavourites() -> [String] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        var arrayFavourites : [String] = []
        
        // Si tenemos datos de Favoritos en Core Data los leeremos si no devolveremos array vacío
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                arrayFavourites = NSKeyedUnarchiver.unarchiveObject(with: results![0].value(forKey: "arrayNames") as! Data) as! [String]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        return arrayFavourites
    }
    
}
