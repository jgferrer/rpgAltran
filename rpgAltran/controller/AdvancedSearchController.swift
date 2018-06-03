//
//  AdvancedSearchController.swift
//  rpgAltran
//
//  Created by Jose Gabriel Ferrer on 8/5/18.
//  Copyright © 2018 Jose Gabriel Ferrer. All rights reserved.
//

import Foundation
import UIKit

class AdvancedSearchController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var professions: [String] = []
    var instanceOfVC: ViewController!
    var professionSelected: String = ""
    
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var professionSelector: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return professions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return professions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.professionSelected = professions[row]
        print(professionSelected)
    }
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        professionSelector.delegate = self
        professionSelector.dataSource = self
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        lblSearch.text = "Select profession:"
        
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        let searchPredicate = NSPredicate(format: "SELF.professions CONTAINS[c] %@", professionSelected)
        let array = (instanceOfVC.brastlewarkFiltered as NSArray).filtered(using: searchPredicate)
        instanceOfVC.brastlewarkFiltered = array as NSArray
        instanceOfVC.gnomesTable.reloadData()
        instanceOfVC.blurEffect.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearFilter(_ sender: Any) {
        instanceOfVC.brastlewarkFiltered = instanceOfVC.brastlewark
        instanceOfVC.gnomesTable.reloadData()
        instanceOfVC.blurEffect.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
