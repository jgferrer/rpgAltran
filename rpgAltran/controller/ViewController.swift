//
//  ViewController.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 1/4/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import CoreData
import RNNotificationView

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITabBarDelegate {

    private let refreshControl = UIRefreshControl()
    var brastlewark : NSArray = []
    var brastlewarkFiltered : NSArray = []
    var gnomeSelected : Gnome?
    
    @IBOutlet weak var gnomesTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tabBarAll: UITabBarItem!
    @IBOutlet weak var tabBarFavourites: UITabBarItem!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var btnAdvSearch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gnomesTable.delegate = self
        gnomesTable.dataSource = self
        searchBar.delegate = self
        tabBar.delegate = self
        
        tabBar.selectedItem = tabBar.items?[0]
        searchBar.placeholder = "Name"
        
        // Configure Refresh Control
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Updating gnomes...")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            gnomesTable.refreshControl = refreshControl
        } else {
            gnomesTable.addSubview(refreshControl)
        }
        
        ViewControllerUtils.shared.showActivityIndicator(uiView: self.view)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gnomes")
        
        // Si tenemos datos de gnomos en Core Data los leeremos si no llamaremos a getJsonFromUrl
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                let arrayGnomes = NSKeyedUnarchiver.unarchiveObject(with: results![0].value(forKey: "arrayData") as! Data)
                self.brastlewark = arrayGnomes as! NSArray
                
                self.brastlewarkFiltered = self.brastlewark.sortAlphabetically(by: "name")
                //self.brastlewarkFiltered = self.brastlewark
                
                self.refreshControl.endRefreshing()
                self.gnomesTable.reloadData()
                ViewControllerUtils.shared.hideActivityIndicator(uiView: self.view)
            } else {
                getJsonFromUrl()
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc private func refreshData(_ sender: Any) {
        if tabBar.selectedItem == tabBar.items?[0] {
            getJsonFromUrl()
        } else {
            filterGnomes(searchText: "FAVOURITES")
            self.refreshControl.endRefreshing()
        }
    }
    
    func getJsonFromUrl(){
        let url = NSURL(string: Constants.URLGnomes)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in

            guard let data = data else {
                OperationQueue.main.addOperation({
                    self.refreshControl.endRefreshing()
                    
                    let notification = RNNotificationView()
                    notification.titleFont = UIFont.boldSystemFont(ofSize: 16)
                    notification.subtitleFont = UIFont.systemFont(ofSize: 14)
                    notification.show(withImage: UIImage(named: "error"),
                                      title: "Error",
                                      message: "Unable to retrieve gnome data",
                                      duration: 3,
                                      iconSize: CGSize(width: 32, height: 32), // Optional setup
                        onTap: {
                            print("Did tap notification")
                    }
                    )
                })
                return
            }
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                //print(jsonObj!.value(forKey: "Brastlewark")!)
                
                if let gnomeArray = jsonObj!.value(forKey: "Brastlewark") as? NSArray {
                    self.brastlewark = gnomeArray
                    self.brastlewarkFiltered = self.brastlewark.sortAlphabetically(by: "name")
                }
                
                OperationQueue.main.addOperation({
                    self.refreshControl.endRefreshing()
                    self.gnomesTable.reloadData()
                    
                    // ------------------------------------
                    // Guardando / Actualizando en CoreData
                    // ------------------------------------
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gnomes")
                    
                    do {
                        let results = try context.fetch(fetchRequest) as? [NSManagedObject]
                        if results?.count != 0 {
                            // Actualizamos el campo arrayData del item[0]
                            let arrayData = NSKeyedArchiver.archivedData(withRootObject: self.brastlewark)
                            results![0].setValue(arrayData, forKey: "arrayData")
                        } else {
                            // La primera vez hay que crear el item[0]
                            let gnomes = NSEntityDescription.insertNewObject(forEntityName: "Gnomes", into: context) as NSManagedObject
                            let arrayData = NSKeyedArchiver.archivedData(withRootObject: self.brastlewark)
                            gnomes.setValue(arrayData, forKey: "arrayData")
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
                    ViewControllerUtils.shared.hideActivityIndicator(uiView: self.view)
                })
            } else {
                OperationQueue.main.addOperation({
                    self.refreshControl.endRefreshing()
                    
                    let notification = RNNotificationView()
                    notification.titleFont = UIFont.boldSystemFont(ofSize: 16)
                    notification.subtitleFont = UIFont.systemFont(ofSize: 14)
                    notification.show(withImage: UIImage(named: "error"),
                                            title: "Error",
                                            message: "Unable to retrieve gnome data",
                                            duration: 3,
                                            iconSize: CGSize(width: 32, height: 32), // Optional setup
                        onTap: {
                            print("Did tap notification")
                    }
                    )
                })
            }
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brastlewarkFiltered.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gnomeCell") as! GnomeTableViewCell
        
        cell.gnomeCell.layer.cornerRadius = cell.gnomeCell.frame.height / 2
        
        let curGnome = Gnome(with: brastlewarkFiltered[indexPath.row] as? NSDictionary)
        
        cell.gnomeName.text = curGnome.name
        cell.gnomeAge.text = "Age: \(curGnome.age!)"
        let url = URL(string: curGnome.thumbnail!)
        cell.gnomeImage.kf.setImage(with: url)
        cell.gnomeImage.layer.cornerRadius = cell.gnomeImage.frame.height / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let gnomeDict = brastlewarkFiltered[indexPath.row] as? NSDictionary {
            gnomeSelected = Gnome(with: gnomeDict)
            performSegue(withIdentifier: "showGnomeDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showGnomeDetail" {
            let vc = segue.destination as? GnomeDetailController
            vc?.gnome = gnomeSelected
            vc?.instanceOfVC = self
        } else if segue.identifier == "showAdvancedSearch" {
            let vc = segue.destination as? AdvancedSearchController
            vc?.professions = getDifferentProfessions()
            vc?.instanceOfVC = self
        } else if segue.identifier == "showLoginScreen" {
            let vc = segue.destination as? LoginScreenController
            vc?.instanceOfVC = self
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchText != "" else {
            allGnomes()
            return
        }
        filterGnomes(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            searchBar.enable()
            btnAdvSearch.isEnabled = true
            allGnomes()
        } else if item.tag == 1 {
            searchBar.disable()
            btnAdvSearch.isEnabled = false
            filterGnomes(searchText: "FAVOURITES")
        } else {
            self.blurEffect.isHidden = false
            performSegue(withIdentifier: "showLoginScreen", sender: self)
        }
    }
    
    func allGnomes() {
        self.searchBar.text = ""
        self.brastlewarkFiltered = brastlewark.sortAlphabetically(by: "name")
        
        DispatchQueue.main.async(execute: {
            self.gnomesTable.reloadData()
            self.gnomesTable.contentOffset = .zero
            self.gnomesTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        })
        
    }
    
    private func filterGnomes(searchText: String) {
        
        var searchPredicate : NSPredicate
        
        if searchText == "FAVOURITES" {
            let arrayFavourites = FavouritesUtils.shared.getFavourites()
            searchPredicate = NSPredicate(format: "SELF.id IN %@", arrayFavourites)
        } else {
            searchPredicate = NSPredicate(format: "SELF.name CONTAINS[c] %@", searchText)
        }
        
        let array = (self.brastlewark as NSArray).filtered(using: searchPredicate) as NSArray
        self.brastlewarkFiltered = array.sortAlphabetically(by: "name")
        
        //self.brastlewarkFiltered = array as NSArray
        
        self.gnomesTable.reloadData()
    }
    
    
    func getDifferentProfessions() -> [String] {
        let allProfessions = brastlewark.value(forKey: "professions") as! NSArray
        var differentProfessions : [String] = []
        for professions in allProfessions {
            for profession in professions as! NSArray {
                differentProfessions.append((profession as! String).trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        //print(Set<String>(differentProfessions))
        let professions = [String](Set<String>(differentProfessions)).sorted{ $0 < $1 }
        
        return professions
    }
    
    @IBAction func showAdvancedSearch(_ sender: Any) {
        searchBar.resignFirstResponder()
        self.blurEffect.isHidden = false
        performSegue(withIdentifier: "showAdvancedSearch", sender: self)
    }
    
    
}

extension NSArray {
    func sortAlphabetically(by filter: String) -> NSArray {
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: filter, ascending: true)
        let sortedResults: NSArray = self.sortedArray(using: [descriptor]) as NSArray
        return sortedResults
    }
}

extension UISearchBar {
    func enable() {
        isUserInteractionEnabled = true
        alpha = 1.0
    }
    
    func disable() {
        isUserInteractionEnabled = false
        alpha = 0.5
        text = ""
    }
}

