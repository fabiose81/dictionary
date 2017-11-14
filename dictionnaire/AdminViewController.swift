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
    
   var motsFrancais = [String: String]()
   var motsAnglais = [String: String]()
    
   var userDefaultsManager = UserDefaultsManager()
    
   override func viewDidLoad() {
        
        if userDefaultsManager.doesKeyExist(theKey: "motsFrancais") && userDefaultsManager.doesKeyExist(theKey: "motsAnglais")
        {
            motsFrancais =  userDefaultsManager.getValue(theKey: "motsFrancais") as! [String: String]
            motsAnglais =  userDefaultsManager.getValue(theKey: "motsAnglais") as! [String: String]
        }
        
        super.viewDidLoad()
    }
    
    @IBAction func actionAjouterMot(_ sender: UIButton) {
        let tf1 =  String(describing: textFieldMotFrancais.text!).trimmingCharacters(in: .whitespaces)
        let tf2 =  String(describing: textFieldMotAnglais.text!).trimmingCharacters(in: .whitespaces)
        
        if tf1 != "" && tf2 != ""
        {
           motsFrancais.updateValue(tf2, forKey: tf1)
           motsAnglais.updateValue(tf1, forKey: tf2)
            
           userDefaultsManager.setKey(theValue: motsFrancais as AnyObject, key: "motsFrancais")
           userDefaultsManager.setKey(theValue: motsAnglais as AnyObject, key: "motsAnglais")
            
           userDefaultsManager.setKey(theValue: true as AnyObject, key: "misAJour")
        
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
        return motsFrancais.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:nil)
        
        let keyFrancais = Array(motsFrancais.keys)[indexPath.row]
        
        cell.textLabel!.text = "\(keyFrancais) - \(String(describing: motsFrancais[keyFrancais]))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let keyFrancais = Array(motsFrancais.keys)[indexPath.row]
            let keyAnglais = motsFrancais[keyFrancais]
            
            motsFrancais.removeValue(forKey:keyFrancais)
            motsFrancais.removeValue(forKey: keyAnglais!)
            
            userDefaultsManager.setKey(theValue: motsFrancais as AnyObject, key: "motsFrancais")
            userDefaultsManager.setKey(theValue: motsFrancais as AnyObject, key: "motsFrancais")
            
            userDefaultsManager.setKey(theValue: true as AnyObject, key: "misAJour")
            
            tableViewMotAjoute.reloadData()
        }
    }
}
