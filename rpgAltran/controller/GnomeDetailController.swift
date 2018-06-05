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
import AudioToolbox

class GnomeDetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITabBarDelegate {
    
    var gnome: Gnome?
    var favourite: Bool = false
    var gnomeCount: GnomeCount?
    
    var instanceOfVC:ViewController!
    
    @IBOutlet weak var gnomeAge: UILabel!
    @IBOutlet weak var gnomeHairColor: UILabel!
    @IBOutlet weak var gnomeWeight: UILabel!
    @IBOutlet weak var gnomeHeight: UILabel!
    @IBOutlet weak var gnomeImage: UIImageView!
    @IBOutlet weak var gnomeName: UILabel!
    @IBOutlet weak var gnomeProfessions: UILabel!
    @IBOutlet weak var noFriendsImage: UIImageView!
    @IBOutlet weak var gnomeFavourite: UIImageView!
    @IBOutlet weak var gnomeCommentsBar: UITabBar!
    
    override func viewDidLoad()
    {
        gnomeCommentsBar.delegate = self
        gnomeCommentsBar.selectedItem = gnomeCommentsBar.items?[0]
        
        if let tabItems = self.gnomeCommentsBar.items as NSArray?
        {
            let tabItem = tabItems[0] as! UITabBarItem
            tabItem.isEnabled = false
        }
        
        // OBTENER NÚMERO DE COMENTARIOS DEL GNOMO SELECCIONADO
        getCommentsCount(for: (gnome?.id)!) { (result) in
            switch result {
            case .success(let result):
                self.gnomeCount = result
                if (self.gnomeCount?.count)! > 0 {
                    if let tabItems = self.gnomeCommentsBar.items as NSArray?
                    {
                        let tabItem = tabItems[0] as! UITabBarItem
                        tabItem.isEnabled = true
                        tabItem.badgeValue = "\((self.gnomeCount?.count)!)"
                    }
                }
            case.failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
        
        /*
        getComments(for: (gnome?.id)!) { (result) in
            switch result {
            case .success(let comments):
                self.gnomeComments = comments
                print(comments)
                if let tabItems = self.gnomeCommentsBar.items as NSArray?
                {
                    let tabItem = tabItems[0] as! UITabBarItem
                    tabItem.badgeValue = "\(comments.count)"
                }
            case .failure(let error):
                fatalError("error: \(error.localizedDescription)")
            }
        }
        */
        
        gnomeName.text = gnome?.name
        gnomeAge.text = "\(gnome!.age!)"
        gnomeHairColor.text = "\(gnome?.hair_color ?? "")"
        gnomeWeight.text = "\(gnome!.weight!)"
        gnomeHeight.text = "\(gnome!.height!)"
        
        let url = URL(string: (gnome?.thumbnail)!)
        gnomeImage.kf.setImage(with: url)
        gnomeImage.layer.cornerRadius = gnomeImage.frame.height / 2
        
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(GnomeDetailController.singleTapping(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        gnomeFavourite.addGestureRecognizer(tapGesture)
        gnomeFavourite.isUserInteractionEnabled = true
        
        if FavouritesUtils.shared.isFavourite(id: (gnome?.id)!){
            gnomeFavourite.image = UIImage(named: "favourite")
            self.favourite = true
        } else {
            gnomeFavourite.image = UIImage(named: "noFavourite")
            self.favourite = false
        }
        
        noFriendsImage.isHidden = (gnome?.friends?.count)! > 0
        
        gnomeProfessions.text = ""
        
        var arrProfessions : [String] = []
        for profession in (gnome?.professions)! {
            arrProfessions.append(profession.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        let listGnomeProfessions = arrProfessions.sorted{ $0 < $1 }.joined(separator: ", ")
        guard listGnomeProfessions == "" else {
            gnomeProfessions.text = listGnomeProfessions + "."
            return
        }
        gnomeProfessions.sizeToFit()
        
    }
    
    @objc func singleTapping(_ sender: UITapGestureRecognizer) {
        if self.favourite {
            gnomeFavourite.image = UIImage(named: "noFavourite")
            let searchPredicate = NSPredicate(format: "SELF.id != %i", (gnome?.id)!)
            let array = (instanceOfVC.brastlewarkFiltered as NSArray).filtered(using: searchPredicate)
            instanceOfVC.brastlewarkFiltered = array as NSArray
            FavouritesUtils.shared.removeFavourite(id: (gnome?.id)!)
        } else {
            gnomeFavourite.image = UIImage(named: "favourite")
            instanceOfVC.brastlewarkFiltered.adding(gnome!)
            FavouritesUtils.shared.addFavourite(id: (gnome?.id)!)
        }
        self.favourite = !self.favourite
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
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
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            performSegue(withIdentifier: "showGnomeComments", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showGnomeComments" {
            let vc = segue.destination as? GnomeCommentsController
            vc?.gnome = gnome
        }
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        instanceOfVC.gnomesTable.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}
