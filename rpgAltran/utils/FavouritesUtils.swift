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
    
    // Añade el nombre del Gnomo a los favoritos
    open func addFavourite(id: Int16) {
        editFavourites(id: id, action: "ADD")
    }
    
    open func removeFavourite(id: Int16) {
        editFavourites(id: id, action: "DELETE")
    }
    
    func editFavourites(id: Int16, action: String) {
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
                var arrayFavourites = NSKeyedUnarchiver.unarchiveObject(with: results![0].value(forKey: "arrayFavourites") as! Data) as! [Int16]
                if action == "ADD" {
                    arrayFavourites.append(id)
                } else if action == "DELETE" {
                    arrayFavourites = arrayFavourites.filter{$0 != id}
                }
                let arrayData = NSKeyedArchiver.archivedData(withRootObject: arrayFavourites)
                results![0].setValue(arrayData, forKey: "arrayFavourites")
            } else {
                // La primera vez hay que crear el item[0]
                let gnomes = NSEntityDescription.insertNewObject(forEntityName: "Favourites", into: context) as NSManagedObject
                let arrayData = NSKeyedArchiver.archivedData(withRootObject: [id])
                gnomes.setValue(arrayData, forKey: "arrayFavourites")
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
    }
    
    // ---------------------------------------------------------
    // Devuelve un array con los nombres de los Gnomos Favoritos
    // ---------------------------------------------------------
    open func getFavourites() -> [Int16] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        var arrayFavourites : [Int16] = []
        
        // Si tenemos datos de Favoritos en Core Data los leeremos si no devolveremos array vacío
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                arrayFavourites = NSKeyedUnarchiver.unarchiveObject(with: results![0].value(forKey: "arrayFavourites") as! Data) as! [Int16]
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        return arrayFavourites
    }
    
    // Devuelve True si tenemos el Gnomo en favoritos y False si no lo tenemos
    open func isFavourite(id: Int16) -> Bool {
        let arrayFavourites = getFavourites()
        return arrayFavourites.contains(id)
    }
    
}
