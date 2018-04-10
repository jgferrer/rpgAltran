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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    private let refreshControl = UIRefreshControl()
    
    let URLGnomes = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
    var brastlewark : NSArray = []
    var filtered : NSArray = []
    var gnomeSelected : Gnome?
    var searchActive : Bool = false
    
    var gnomeArrs : [Gnome] = []
    
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
        getJsonFromUrl();
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
                    self.filtered = self.brastlewark
                    //sleep(4)
                }
                
                OperationQueue.main.addOperation({
                    self.refreshControl.endRefreshing()
                    self.gnomesTable.reloadData()
                    ViewControllerUtils.shared.hideActivityIndicator(uiView: self.view)
                })
            }
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return brastlewark.count
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gnomeCell") as! GnomeTableViewCell
        
        cell.gnomeCell.layer.cornerRadius = cell.gnomeCell.frame.height / 2
        
        //let curGnome = Gnome(with: brastlewark[indexPath.row] as? NSDictionary)
        let curGnome = Gnome(with: filtered[indexPath.row] as? NSDictionary)
        
        
        cell.gnomeName.text = curGnome.name
        cell.gnomeAge.text = "Age: \(curGnome.age!)"
        let url = URL(string: curGnome.thumbnail!)
        cell.gnomeImage.kf.setImage(with: url)
        cell.gnomeImage.layer.cornerRadius = cell.gnomeImage.frame.height / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*
        if let gnomeDict = brastlewark[indexPath.row] as? NSDictionary {
            gnomeSelected = Gnome(with: gnomeDict)
            performSegue(withIdentifier: "showGnomeDetail", sender: self)
        }
        */
        if let gnomeDict = filtered[indexPath.row] as? NSDictionary {
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
            self.filtered = self.brastlewark
            self.gnomesTable.reloadData()
            return
        }
        
        let searchPredicate = NSPredicate(format: "SELF.name CONTAINS[c] %@", searchText)
        let array = (self.brastlewark as NSArray).filtered(using: searchPredicate)
        self.filtered = array as NSArray
        self.gnomesTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
}
