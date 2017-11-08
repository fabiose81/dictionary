//
//  ViewController.swift
//  dictionnaire
//
//  Created by eleves on 2017-11-08.
//  Copyright © 2017 eleves. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   @IBOutlet weak var textField1: UITextField!
   @IBOutlet weak var textField2: UITextField!
    
   @IBOutlet weak var tableViewMotAjoute: UITableView!
    
   var motAjoute = [String]()
   var dictionaryFrancaisAnglais = [String: String]()
   var dictionaryAnglaisFrancais = [String: String]()
    
   var userDefaultsManager = UserDefaultsManager()
    
    override func viewDidLoad() {
        if userDefaultsManager.doesKeyExist(theKey: "dictionaryFrancaisAnglais") && userDefaultsManager.doesKeyExist(theKey: "dictionaryAnglaisFrancais")
        {
            dictionaryFrancaisAnglais =  userDefaultsManager.getValue(theKey: "dictionaryFrancaisAnglais") as! [String: String]
            dictionaryAnglaisFrancais =  userDefaultsManager.getValue(theKey: "dictionaryAnglaisFrancais") as! [String: String]
            
            for dict in dictionaryFrancaisAnglais
            {
                motAjoute.append("\(dict.key) = \(dict.value)")
            }
            
            tableViewMotAjoute.reloadData()
        }
        
        super.viewDidLoad()
    }
    
    @IBAction func actionAjouterMot(_ sender: UIButton) {
        let tf1 =  String(describing: textField1.text!).trimmingCharacters(in: .whitespaces)
        let tf2 =  String(describing: textField2.text!).trimmingCharacters(in: .whitespaces)
        
        if tf1 != "" && tf2 != ""
        {
          dictionaryFrancaisAnglais.updateValue(tf2, forKey: tf1)
          dictionaryAnglaisFrancais.updateValue(tf1, forKey: tf2)
            
          userDefaultsManager.setKey(theValue: dictionaryFrancaisAnglais as AnyObject, key: "dictionaryFrancaisAnglais")
          userDefaultsManager.setKey(theValue: dictionaryAnglaisFrancais as AnyObject, key: "dictionaryAnglaisFrancais")
            
          motAjoute.append("\(tf1) = \(tf2)")
            
          tableViewMotAjoute.reloadData()
        }
        else
        {
            print("erro !!")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return motAjoute.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:nil)
        cell.textLabel!.text = motAjoute[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let keyFrancais = String(describing: motAjoute[indexPath.row].components(separatedBy: "=").first!.trimmingCharacters(in: .whitespaces))
            let keyAnglais = String(describing: motAjoute[indexPath.row].components(separatedBy: "=").last!.trimmingCharacters(in: .whitespaces))
        
            dictionaryFrancaisAnglais.removeValue(forKey:keyFrancais)
            dictionaryAnglaisFrancais.removeValue(forKey: keyAnglais)
            
            userDefaultsManager.setKey(theValue: dictionaryFrancaisAnglais as AnyObject, key: "dictionaryFrancaisAnglais")
            userDefaultsManager.setKey(theValue: dictionaryAnglaisFrancais as AnyObject, key: "dictionaryAnglaisFrancais")
            
            motAjoute.remove(at: indexPath.row)
            
            tableViewMotAjoute.reloadData()
        }
    }
}
