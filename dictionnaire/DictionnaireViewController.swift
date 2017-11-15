//
//  ViewController.swift
//  dictionnaire
//
//  Created by eleves on 2017-11-02.
//  Copyright © 2017 eleves. All rights reserved.
//

import UIKit

class DictionnaireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var labelResultat: UILabel!
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBOutlet weak var tableViewHistoriqueRecherche: UITableView!
    
    var motsFrancais = [String: [String]]()
    var motsAnglais = [String: [String]]()
    
    var dictionnaireFrancaisAnglais = [String: String]()
    var dictionnaireAnglaisFrancais = [String: String]()
    
    var dictionnaireFrancaisAnglaisSorted = [(key: String, value: [String])]()
    var dictionnaireAnglaisFrancaisSorted = [(key: String, value: [String])]()
    
    var userDefaultsManager = UserDefaultsManager()
    
    var segControlSelected = 0

    @IBAction func actionMisAJour(_ sender: UIButton) {
        if userDefaultsManager.doesKeyExist(theKey: "misAJour") {
            let misAJour =  userDefaultsManager.getValue(theKey: "misAJour") as! Bool
            if misAJour
            {
                loadDictionnaire()
                userDefaultsManager.setKey(theValue: false as Bool as AnyObject, key: "misAJour")
                tableViewHistoriqueRecherche.reloadData()
            }
        }
    }
    
    @IBAction func actionSegControl(_ sender: UISegmentedControl) {
        segControlSelected = sender.selectedSegmentIndex
        tableViewHistoriqueRecherche.reloadData()
    }
    
    override func viewDidLoad() {
        
        viewTop.layer.borderColor = UIColor(rgb: 0x366295).cgColor
        viewTop.layer.borderWidth = 5
        
        //segControl.subviews[0].tintColor = UIColor(rgb: 0xED2024)
                
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
        
        if userDefaultsManager.doesKeyExist(theKey: "dictionnaireFrancaisAnglais") && userDefaultsManager.doesKeyExist(theKey: "dictionnaireAnglaisFrancais")
        {
             dictionnaireFrancaisAnglais =  userDefaultsManager.getValue(theKey: "dictionnaireFrancaisAnglais") as! [String: String]
             dictionnaireAnglaisFrancais =  userDefaultsManager.getValue(theKey: "dictionnaireAnglaisFrancais") as! [String: String]
   
            for element in dictionnaireFrancaisAnglais
            {
                if motsFrancais[String(element.key.uppercased().first!)] == nil
                {
                    motsFrancais.updateValue([element.key], forKey: String(element.key.uppercased().first!))
                }
                else
                {
                    var elementTemp = [String]()
                    elementTemp = motsFrancais[String(element.key.uppercased().first!)]!
                    elementTemp.append(element.key)
                    motsFrancais.updateValue(elementTemp , forKey: String(element.key.uppercased().first!))
                }
            }
            
            for element in dictionnaireAnglaisFrancais
            {
                if motsAnglais[String(element.key.uppercased().first!)] == nil
                {
                    motsAnglais.updateValue([String(element.key)], forKey: String(element.key.uppercased().first!))
                }
                else
                {
                    var elementTemp = [String]()
                    elementTemp = motsAnglais[String(element.key.uppercased().first!)]!
                    elementTemp.append(element.key)
                    
                    motsAnglais.updateValue(elementTemp , forKey: String(element.key.uppercased().first!))
                }
            }
            
            dictionnaireFrancaisAnglaisSorted = motsFrancais.sorted{ $0.key < $1.key }
            dictionnaireAnglaisFrancaisSorted = motsAnglais.sorted{ $0.key < $1.key }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        
        if segControlSelected == 0
        {
            if let label =  cell.viewWithTag(100) as! UILabel! {
                label.text = dictionnaireFrancaisAnglaisSorted[indexPath.section].value[indexPath.row]
            }
        }
        else
        {
            if let label =  cell.viewWithTag(100) as! UILabel! {
                label.text = dictionnaireAnglaisFrancaisSorted[indexPath.section].value[indexPath.row]
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segControlSelected == 0
        {
            return dictionnaireFrancaisAnglaisSorted[section].value.count
        }
        
        return dictionnaireAnglaisFrancaisSorted[section].value.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segControlSelected == 0
        {
            return dictionnaireFrancaisAnglaisSorted.count
        }
        
        return dictionnaireAnglaisFrancaisSorted.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segControlSelected == 0
        {
            return dictionnaireFrancaisAnglaisSorted[section].key
        }
        
        return dictionnaireAnglaisFrancaisSorted[section].key
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segControlSelected == 0
        {
            let key = dictionnaireFrancaisAnglaisSorted[indexPath.section].value[indexPath.row]
            labelResultat.text = dictionnaireFrancaisAnglais[key]
        }
        else
        {
            let key = dictionnaireAnglaisFrancaisSorted[indexPath.section].value[indexPath.row]
            labelResultat.text = dictionnaireAnglaisFrancais[key]
        }
    }
}

