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
    
    var dictionaryFrancaisAnglais = [String: [String]]()
    var dictionaryAnglaisFrancais = [String: [String]]()
    
    var userDefaultsManager = UserDefaultsManager()
    
    var segControlSelected = 0
    
    @IBAction func actionTextField1(_ sender: UITextField) {
        traduire(_mot: String(describing: sender.text!).trimmingCharacters(in: .whitespaces).uppercased())
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

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       loadDictionnaire()
    }
    
    func loadDictionnaire()
    {
        if userDefaultsManager.doesKeyExist(theKey: "dictionaryFrancaisAnglais") && userDefaultsManager.doesKeyExist(theKey: "dictionaryAnglaisFrancais")
        {
            let dictionaryFrancaisAnglaisTemp =  userDefaultsManager.getValue(theKey: "dictionaryFrancaisAnglais") as! [String: String]
            let dictionaryAnglaisFrancaisTemp =  userDefaultsManager.getValue(theKey: "dictionaryAnglaisFrancais") as! [String: String]
            
            
           //dictionaryFrancaisAnglais = dictionaryFrancaisAnglais.sorted{ $0.key < $1.key }
     
            for element in dictionaryFrancaisAnglaisTemp{
                if dictionaryFrancaisAnglais[String(describing: element.key.uppercased().first)] == nil
                {
                    dictionaryFrancaisAnglais.updateValue([element.key], forKey: String(describing: element.key.uppercased().first))
                }else{
                    
                    var y = [String]()
                    y=dictionaryFrancaisAnglais[String(describing: element.key.uppercased().first)]!
                    y.append(element.key)
                    
                    dictionaryFrancaisAnglais.updateValue(y , forKey: String(describing: element.key.uppercased().first))
                }
            }
            
            for element in dictionaryAnglaisFrancaisTemp{
                if dictionaryAnglaisFrancais[String(describing: element.key.uppercased().first)] == nil
                {
                    dictionaryAnglaisFrancais.updateValue([element.key], forKey: String(describing: element.key.uppercased().first))
                }else{
                    
                    var y = [String]()
                    y=dictionaryAnglaisFrancais[String(describing: element.key.uppercased().first)]!
                    y.append(element.key)
                    
                    dictionaryAnglaisFrancais.updateValue(y , forKey: String(describing: element.key.uppercased().first))
                }
            }
        }
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:nil)
        
        if segControlSelected == 0
        {
            let key = dictionaryFrancaisAnglais[Array(dictionaryFrancaisAnglais.keys)[indexPath.section]]!
            cell.textLabel!.text = key[indexPath.row]
        }else{
           let  key = dictionaryAnglaisFrancais[Array(dictionaryAnglaisFrancais.keys)[indexPath.section]]!
            cell.textLabel!.text = key[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segControlSelected == 0
        {
           return (dictionaryFrancaisAnglais[Array(dictionaryFrancaisAnglais.keys)[section]]?.count)!
        }
        
       return (dictionaryAnglaisFrancais[Array(dictionaryAnglaisFrancais.keys)[section]]?.count)!
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segControlSelected == 0
        {
            return dictionaryFrancaisAnglais.keys.count
        }
        return dictionaryAnglaisFrancais.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segControlSelected == 0
        {
            return Array(dictionaryFrancaisAnglais.keys)[section]
        }
        
        return Array(dictionaryAnglaisFrancais.keys)[section]
    }
}

