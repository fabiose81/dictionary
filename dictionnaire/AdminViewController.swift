//
//  ViewController.swift
//  dictionnaire
//
//  Created by eleves on 2017-11-08.
//  Copyright © 2017 eleves. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

   @IBOutlet weak var viewTop: UIView!
    
   @IBOutlet weak var textFieldMotFrancais: UITextField!
   @IBOutlet weak var textFieldMotAnglais: UITextField!
    
   @IBOutlet weak var tableViewMotAjoute: UITableView!
    
   var dictionnaireFrancaisAnglais = [String: String]()
   var dictionnaireAnglaisFrancais = [String: String]()
    
   var dictionnaireFrancaisAnglaisSorted = [(key: String, value: String)]()
    
   var userDefaultsManager = UserDefaultsManager()
    
   override func viewDidLoad() {
    
        viewTop.layer.borderColor = UIColor(rgb: 0x366295).cgColor
        viewTop.layer.borderWidth = 2
    
        tableViewMotAjoute.layer.borderColor = UIColor(rgb: 0x366295).cgColor
        tableViewMotAjoute.layer.borderWidth = 2
    
        if userDefaultsManager.doesKeyExist(theKey: "dictionnaireFrancaisAnglais") && userDefaultsManager.doesKeyExist(theKey: "dictionnaireAnglaisFrancais")
        {
            dictionnaireFrancaisAnglais =  userDefaultsManager.getValue(theKey: "dictionnaireFrancaisAnglais") as! [String: String]
            dictionnaireAnglaisFrancais =  userDefaultsManager.getValue(theKey: "dictionnaireAnglaisFrancais") as! [String: String]
            
            dictionnaireFrancaisAnglaisSorted = dictionnaireFrancaisAnglais.sorted(by: <)
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
            
           dictionnaireFrancaisAnglaisSorted = dictionnaireFrancaisAnglais.sorted(by: <)
            
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
        return dictionnaireFrancaisAnglaisSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if let label1 =  cell.viewWithTag(100) as! UILabel! {
            label1.text = dictionnaireFrancaisAnglaisSorted[indexPath.row].key
        }
        
        if let label2 =  cell.viewWithTag(200) as! UILabel! {
            label2.text = dictionnaireFrancaisAnglaisSorted[indexPath.row].value
        }
        
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
            
            dictionnaireFrancaisAnglaisSorted.remove(at: indexPath.row)
            
            userDefaultsManager.setKey(theValue: dictionnaireFrancaisAnglais as AnyObject, key: "dictionnaireFrancaisAnglais")
            userDefaultsManager.setKey(theValue: dictionnaireAnglaisFrancais as AnyObject, key: "dictionnaireAnglaisFrancais")
            
            userDefaultsManager.setKey(theValue: true as AnyObject, key: "misAJour")
            
            tableViewMotAjoute.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldMotFrancais.resignFirstResponder()
        return true
    }
}
