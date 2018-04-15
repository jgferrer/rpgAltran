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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    private let refreshControl = UIRefreshControl()
    
    let URLGnomes = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
    var brastlewark : NSArray = []
    var brastlewarkFiltered : NSArray = []
    var gnomeSelected : Gnome?
    var searchActive : Bool = false
    
    @IBOutlet weak var gnomesTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gnomesTable.delegate = self
        gnomesTable.dataSource = self
        searchBar.delegate = self
        
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
                self.brastlewarkFiltered = self.brastlewark
                self.refreshControl.endRefreshing()
                self.gnomesTable.reloadData()
                ViewControllerUtils.shared.hideActivityIndicator(uiView: self.view)
                /*
                let alert = UIAlertView()
                alert.title = "Core Data"
                alert.message = "Leyendo desde Core Data"
                alert.addButton(withTitle: "Ok")
                alert.show()
                */
            } else {
                getJsonFromUrl()
                /*
                let alert = UIAlertView()
                alert.title = "Internet"
                alert.message = "Leyendo desde internet"
                alert.addButton(withTitle: "Ok")
                alert.show()
                */
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc private func refreshData(_ sender: Any) {
        getJsonFromUrl()
    }
    
    func getJsonFromUrl(){
        let url = NSURL(string: self.URLGnomes)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in

            guard let data = data else { return }
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                //print(jsonObj!.value(forKey: "Brastlewark")!)
                
                if let gnomeArray = jsonObj!.value(forKey: "Brastlewark") as? NSArray {
                    self.brastlewark = gnomeArray
                    self.brastlewarkFiltered = self.brastlewark
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
                    //
                    
                    ViewControllerUtils.shared.hideActivityIndicator(uiView: self.view)
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
        if segue.identifier == "showGnomeDetail"
        {
            let vc = segue.destination as? GnomeDetailController
            vc?.gnome = gnomeSelected
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchText != "" else {
            self.brastlewarkFiltered = self.brastlewark
            self.gnomesTable.reloadData()
            return
        }
        
        let searchPredicate = NSPredicate(format: "SELF.name CONTAINS[c] %@", searchText)
        let array = (self.brastlewark as NSArray).filtered(using: searchPredicate)
        self.brastlewarkFiltered = array as NSArray
        self.gnomesTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
