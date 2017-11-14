//
//  ViewController.swift
//  dictionnaire
//
//  Created by eleves on 2017-11-08.
//  Copyright © 2017 eleves. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   @IBOutlet weak var textFieldMotFrancais: UITextField!
   @IBOutlet weak var textFieldMotAnglais: UITextField!
    
   @IBOutlet weak var tableViewMotAjoute: UITableView!
    
   var dictionaryFrancaisAnglais = [String: String]()
   var dictionaryAnglaisFrancais = [String: String]()
    
   var userDefaultsManager = UserDefaultsManager()
    
    override func viewDidLoad() {
       
        
        if userDefaultsManager.doesKeyExist(theKey: "dictionaryFrancaisAnglais") && userDefaultsManager.doesKeyExist(theKey: "dictionaryAnglaisFrancais")
        {
            dictionaryFrancaisAnglais =  userDefaultsManager.getValue(theKey: "dictionaryFrancaisAnglais") as! [String: String]
            dictionaryAnglaisFrancais =  userDefaultsManager.getValue(theKey: "dictionaryAnglaisFrancais") as! [String: String]
        }
        
        super.viewDidLoad()
    }
    
    @IBAction func actionAjouterMot(_ sender: UIButton) {
        let tf1 =  String(describing: textFieldMotFrancais.text!).trimmingCharacters(in: .whitespaces)
        let tf2 =  String(describing: textFieldMotAnglais.text!).trimmingCharacters(in: .whitespaces)
        
        if tf1 != "" && tf2 != ""
        {
           dictionaryFrancaisAnglais.updateValue(tf2, forKey: tf1)
           dictionaryAnglaisFrancais.updateValue(tf1, forKey: tf2)
            
           userDefaultsManager.setKey(theValue: dictionaryFrancaisAnglais as AnyObject, key: "dictionaryFrancaisAnglais")
           userDefaultsManager.setKey(theValue: dictionaryAnglaisFrancais as AnyObject, key: "dictionaryAnglaisFrancais")
        
           textFieldMotFrancais.text = ""
           textFieldMotAnglais.text = ""
            
           textFieldMotFrancais.becomeFirstResponder()
            
           tableViewMotAjoute.reloadData()
        }
        else
        {
            let alertController = UIAlertController(title: "Reverse", message: "SVP, remplir les champs", preferredStyle: .alert)

            let defaultAction = UIAlertAction(title: "Fermer", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
        
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionaryFrancaisAnglais.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:nil)
        
        let keyFrancais = Array(dictionaryFrancaisAnglais.keys)[indexPath.row]
        
        cell.textLabel!.text = "\(keyFrancais) - \(String(describing: dictionaryFrancaisAnglais[keyFrancais]))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let keyFrancais = Array(dictionaryFrancaisAnglais.keys)[indexPath.row]
            let keyAnglais = dictionaryFrancaisAnglais[keyFrancais]
            
            dictionaryFrancaisAnglais.removeValue(forKey:keyFrancais)
            dictionaryAnglaisFrancais.removeValue(forKey: keyAnglais!)
            
            userDefaultsManager.setKey(theValue: dictionaryFrancaisAnglais as AnyObject, key: "dictionaryFrancaisAnglais")
            userDefaultsManager.setKey(theValue: dictionaryAnglaisFrancais as AnyObject, key: "dictionaryAnglaisFrancais")
            
            tableViewMotAjoute.reloadData()
        }
    }
}
