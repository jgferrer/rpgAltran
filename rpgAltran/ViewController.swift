//
//  ViewController.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 1/4/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let refreshControl = UIRefreshControl()
    
    let URLGnomes = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
    var brastlewark : NSArray = []
    
    @IBOutlet weak var gnomesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gnomesTable.delegate = self
        gnomesTable.dataSource = self
        
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
                    sleep(4)
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
        return brastlewark.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell()
        
        if let gnomeDict = brastlewark[indexPath.row] as? NSDictionary {
            if let name = gnomeDict.value(forKey: "name") {
                cell.textLabel?.text = name as? String
            }
        } else {
            cell.textLabel?.text = " - NO NAME - "
        }
        
        return cell
    }
    
}



