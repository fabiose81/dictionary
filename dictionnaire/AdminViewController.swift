//
//  ViewController.swift
//  dictionnaire
//
//  Created by eleves on 2017-11-08.
//  Copyright © 2017 eleves. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

   @IBOutlet weak var textFieldMotFrancais: UITextField!
   @IBOutlet weak var textFieldMotAnglais: UITextField!
    
   @IBOutlet weak var tableViewMotAjoute: UITableView!
    
   var dictionnaireFrancaisAnglais = [String: String]()
   var dictionnaireAnglaisFrancais = [String: String]()
    
   var userDefaultsManager = UserDefaultsManager()
    
   override func viewDidLoad() {
        
        if userDefaultsManager.doesKeyExist(theKey: "dictionnaireFrancaisAnglais") && userDefaultsManager.doesKeyExist(theKey: "dictionnaireAnglaisFrancais")
        {
            dictionnaireFrancaisAnglais =  userDefaultsManager.getValue(theKey: "dictionnaireFrancaisAnglais") as! [String: String]
            dictionnaireAnglaisFrancais =  userDefaultsManager.getValue(theKey: "dictionnaireAnglaisFrancais") as! [String: String]
        }
        
        super.viewDidLoad()
    }
    
    @IBAction func actionAjouterMot(_ sender: UIButton) {
        let tf1 =  String(describing: textFieldMotFrancais.text!).trimmingCharacters(in: .whitespaces)
        let tf2 =  String(describing: textFieldMotAnglais.text!).trimmingCharacters(in: .whitespaces)
       
        textFieldMotFrancais.resignFirstResponder()
        textFieldMotAnglais.resignFirstResponder()
        
        if tf1 != "" && tf2 != ""
        {
           dictionnaireFrancaisAnglais.updateValue(tf2, forKey: tf1)
           dictionnaireAnglaisFrancais.updateValue(tf1, forKey: tf2)
            
          let dictionnaireFrancaisAnglaisSorted = dictionnaireFrancaisAnglais.sorted(by: <)
          print(dictionnaireFrancaisAnglaisSorted)
            
           userDefaultsManager.setKey(theValue: dictionnaireFrancaisAnglais as AnyObject, key: "dictionnaireFrancaisAnglais")
           userDefaultsManager.setKey(theValue: dictionnaireAnglaisFrancais as AnyObject, key: "dictionnaireAnglaisFrancais")
            
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
        return dictionnaireFrancaisAnglais.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:nil)
        
        let keyFrancais = Array(dictionnaireFrancaisAnglais.keys)[indexPath.row]
        
        cell.textLabel!.text = "\(keyFrancais) - \(dictionnaireFrancaisAnglais[keyFrancais]!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let keyFrancais = Array(dictionnaireFrancaisAnglais.keys)[indexPath.row]
            let keyAnglais = dictionnaireFrancaisAnglais[keyFrancais]
            
            dictionnaireFrancaisAnglais.removeValue(forKey:keyFrancais)
            dictionnaireAnglaisFrancais.removeValue(forKey: keyAnglais!)
            
            userDefaultsManager.setKey(theValue: dictionnaireFrancaisAnglais as AnyObject, key: "dictionnaireFrancaisAnglais")
            userDefaultsManager.setKey(theValue: dictionnaireAnglaisFrancais as AnyObject, key: "dictionnaireAnglaisFrancais")
            
            userDefaultsManager.setKey(theValue: true as AnyObject, key: "misAJour")
            
            tableViewMotAjoute.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldMotFrancais.resignFirstResponder()
        return true
    }
}
