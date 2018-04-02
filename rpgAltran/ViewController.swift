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

    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let URLGnomes = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
    var brastlewark : NSArray = []
    
    @IBOutlet weak var gnomesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gnomesTable.delegate = self
        gnomesTable.dataSource = self
        
        showActivityIndicatory(uiView: self.view)
        getJsonFromUrl();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getJsonFromUrl(){
        let url = NSURL(string: self.URLGnomes)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in

            guard let data = data else { return }
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                //print(jsonObj!.value(forKey: "Brastlewark")!)
                
                if let gnomeArray = jsonObj!.value(forKey: "Brastlewark") as? NSArray {
                    self.brastlewark = gnomeArray
                    /*
                    for gnome in self.brastlewark{
                        if let gnomeDict = gnome as? NSDictionary {
                            if let name = gnomeDict.value(forKey: "name") {
                                self.gnomeNames.append((name as? String)!)
                            }
                        }
                    }
                    */
                    
                }
                
                OperationQueue.main.addOperation({
                    self.gnomesTable.reloadData()
                    self.hideActivityIndicator(uiView: self.view)
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
    

    func showActivityIndicatory(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    func hideActivityIndicator(uiView: UIView) {
        actInd.stopAnimating()
        container.removeFromSuperview()
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}



