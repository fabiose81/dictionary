//
//  ViewController.swift
//  dictionnaire
//
//  Created by eleves on 2017-11-02.
//  Copyright © 2017 eleves. All rights reserved.
//

import UIKit

class DictionnaireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textField1: UITextField!
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBOutlet weak var tableViewHistoriqueRecherche: UITableView!
    
    var motsFrancais = [String: [String]]()
    var motsAnglais = [String: [String]]()
    
    var dictionnaireFrancaisAnglais = [String: String]()
    var dictionnaireAnglaisFrancais = [String: String]()
    
    var userDefaultsManager = UserDefaultsManager()
    
    var segControlSelected = 0
    
    @IBAction func actionTextField1(_ sender: UITextField) {
        traduire(_mot: String(describing: sender.text!).trimmingCharacters(in: .whitespaces).uppercased())
    }
    
    
    @IBAction func actionMisAJour(_ sender: UIButton) {
        if userDefaultsManager.doesKeyExist(theKey: "misAJour") {
            let misAJour =  userDefaultsManager.getValue(theKey: "misAJour") as! Bool
            if misAJour {
                loadDictionnaire()
                userDefaultsManager.setKey(theValue: false as Bool as AnyObject, key: "misAJour")
                tableViewHistoriqueRecherche.reloadData()
            }
        }
    }
    
    @IBAction func actionSegControl(_ sender: UISegmentedControl) {
        
        segControlSelected = sender.selectedSegmentIndex
        
        if segControlSelected == 0
        {
            textField1.placeholder = "Composer le mot en français"
        }
        else
        {
            textField1.placeholder = "Enter the english word"
        }
        
        tableViewHistoriqueRecherche.reloadData()
    }
    
    private func traduire(_mot: String)
    {
        
        
       /* let seg = segControl.selectedSegmentIndex
        
        if seg == 0
        {
            for mot in dictionaryFrancaisAnglais{
                if mot.key == _mot{
                    for value in mot.value {
                        resultatRecherche.append("\(value.key) = \(value.value)")
                    }
                    tableViewHistoriqueRecherche.reloadData()
                    break
                }
            }
        }
        else
        {
            for mot in dictionaryAnglaisFrancais{
                if mot.key == _mot{
                    for value in mot.value {
                        resultatRecherche.append("\(value.key) = \(value.value)")
                    }
                    tableViewHistoriqueRecherche.reloadData()
                    break
                }
            }
        }
        textField1.text!.trimmingCharacters(in: .whitespaces)*/
    }
    
    override func viewDidLoad() {
        textField1.placeholder = "Composer le mot en français"
        
        segControl.setTitle("Français", forSegmentAt: 0)
        segControl.setTitle("Anglais", forSegmentAt: 1)

        loadDictionnaire()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func loadDictionnaire()
    {
        motsFrancais  = [String: [String]]()
        motsAnglais  = [String: [String]]()
        
        if userDefaultsManager.doesKeyExist(theKey: "motsFrancais") && userDefaultsManager.doesKeyExist(theKey: "motsAnglais")
        {
            let motsFrancaisTemp =  userDefaultsManager.getValue(theKey: "motsFrancais") as! [String: String]
            let motsAnglaisTemp =  userDefaultsManager.getValue(theKey: "motsAnglais") as! [String: String]
            
            
           //dictionaryFrancaisAnglais = dictionaryFrancaisAnglais.sorted{ $0.key < $1.key }
     
            for element in motsFrancaisTemp{
                if motsFrancais[String(describing: element.key.uppercased().first)] == nil
                {
                    motsFrancais.updateValue([element.key], forKey: String(describing: element.key.uppercased().first))
                }else{
                    var elementTemp = [String]()
                    elementTemp = motsFrancais[String(describing: element.key.uppercased().first)]!
                    elementTemp.append(element.key)
                    
                    motsFrancais.updateValue(elementTemp , forKey: String(describing: element.key.uppercased().first))
                }
                
                //dictionnaireFrancaisAnglais
                
            }
            
            for element in motsAnglaisTemp{
                if motsAnglais[String(describing: element.key.uppercased().first)] == nil
                {
                    motsAnglais.updateValue([element.key], forKey: String(describing: element.key.uppercased().first))
                }else{
                    
                    var elementTemp = [String]()
                    elementTemp = motsAnglais[String(describing: element.key.uppercased().first)]!
                    elementTemp.append(element.key)
                    
                    motsAnglais.updateValue(elementTemp , forKey: String(describing: element.key.uppercased().first))
                }
            }
        }
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:nil)
        
        if segControlSelected == 0
        {
            let section = motsFrancais[Array(motsFrancais.keys)[indexPath.section]]!
            cell.textLabel!.text = section[indexPath.row]
        }else{
           let  section = motsAnglais[Array(motsAnglais.keys)[indexPath.section]]!
            cell.textLabel!.text = section[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segControlSelected == 0
        {
           return (motsFrancais[Array(motsFrancais.keys)[section]]?.count)!
        }
        
       return (motsAnglais[Array(motsAnglais.keys)[section]]?.count)!
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segControlSelected == 0
        {
            return motsFrancais.keys.count
        }
        return motsAnglais.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segControlSelected == 0
        {
            return Array(motsFrancais.keys)[section]
        }
        
        return Array(motsAnglais.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = motsFrancais[Array(motsFrancais.keys)[indexPath.section]]!
        print(section[indexPath.row])
    }
}

