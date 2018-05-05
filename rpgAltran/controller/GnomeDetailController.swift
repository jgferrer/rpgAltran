//
//  GnomeDetailController.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 5/4/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import CoreData

class GnomeDetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var gnome : Gnome?
    
    @IBOutlet weak var gnomeAge: UILabel!
    @IBOutlet weak var gnomeHairColor: UILabel!
    @IBOutlet weak var gnomeWeight: UILabel!
    @IBOutlet weak var gnomeHeight: UILabel!
    @IBOutlet weak var gnomeImage: UIImageView!
    @IBOutlet weak var gnomeName: UILabel!
    @IBOutlet weak var gnomeProfessions: UILabel!
    @IBOutlet weak var noFriendsImage: UIImageView!
    
    override func viewDidLoad()
    {
        gnomeName.text = gnome?.name
        gnomeAge.text = "\(gnome!.age!)"
        gnomeHairColor.text = "\(gnome?.hair_color ?? "")"
        gnomeWeight.text = "\(gnome!.weight!)"
        gnomeHeight.text = "\(gnome!.height!)"
        
        let url = URL(string: (gnome?.thumbnail)!)
        gnomeImage.kf.setImage(with: url)
        gnomeImage.layer.cornerRadius = gnomeImage.frame.height / 2
        
        noFriendsImage.isHidden = (gnome?.friends?.count)! > 0
        
        gnomeProfessions.text = ""
        let listGnomeProfessions = (gnome?.professions)!.joined(separator: ", ")
        guard listGnomeProfessions == "" else {
            gnomeProfessions.text = listGnomeProfessions + "."
            return
        }
        gnomeProfessions.sizeToFit()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gnome?.friends?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCollectionViewCell", for: indexPath) as! FriendsCollectionViewCell

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Gnomes")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let arrayGnomes = NSKeyedUnarchiver.unarchiveObject(with: data.value(forKey: "arrayData") as! Data) as! NSArray
                
                let friendName = gnome?.friends![indexPath.row]

                let predicateString = NSPredicate(format: "%K contains[cd] %@", "name", friendName!)
                let filteredArray = arrayGnomes.filtered(using: predicateString)
                
                let friend = Gnome(with: filteredArray[0] as? NSDictionary)
                let url = URL(string: (friend.thumbnail)!)
                cell.friendImage.kf.setImage(with: url)
                cell.friendImage.layer.cornerRadius = cell.friendImage.frame.height / 2
                cell.friendName.text = friend.name
            }
            
        } catch {
            print("Failed")
        }
        
        return cell
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
