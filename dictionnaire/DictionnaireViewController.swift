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
    
    var dictionaryFrancaisAnglais = [String: [String: String]]()
    var dictionaryAnglaisFrancais = [String: [String: String]]()
    var motRecherche = [String: [String]]()
    
    var resultatRecherche = [String]()
    
    var userDefaultsManager = UserDefaultsManager()
    
    @IBAction func actionTextField1(_ sender: UITextField) {
        traduire(_mot: String(describing: sender.text!).trimmingCharacters(in: .whitespaces).uppercased())
    }
    
    @IBAction func actionSegControl(_ sender: UISegmentedControl) {
        
        let seg = sender.selectedSegmentIndex
        
        if seg == 0
        {
            textField1.placeholder = "Composer le mot en français"
        }
        else
        {
            textField1.placeholder = "Enter the english word"
        }
    }
    
    private func traduire(_mot: String)
    {
        resultatRecherche = [String]()
        
        let seg = segControl.selectedSegmentIndex
        
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
        textField1.text!.trimmingCharacters(in: .whitespaces)
    }
    
    override func viewDidLoad() {
        textField1.placeholder = "Composer le mot en français"
        
        segControl.setTitle("Français", forSegmentAt: 0)
        segControl.setTitle("Anglais", forSegmentAt: 1)
        
        motRecherche.updateValue(["AA"], forKey: "A")
        motRecherche.updateValue(["BB","BBB"], forKey: "B")
        motRecherche.updateValue(["CC","CCC","CCCC"], forKey: "C" )
        
        
        
       /* motRecherche.sorted(by:
            {
                $0.key < $1.key
        })
        */
        
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
            dictionaryFrancaisAnglais =  userDefaultsManager.getValue(theKey: "dictionaryFrancaisAnglais") as! [String: [String: String]]
            dictionaryAnglaisFrancais =  userDefaultsManager.getValue(theKey: "dictionaryAnglaisFrancais") as! [String: [String: String]]
            
            dictionaryFrancaisAnglais.updateValue(["chat":"cat","chien":"dog"], forKey: "C")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:nil)
      
        //var key = dictionaryFrancaisAnglais[Array(dictionaryFrancaisAnglais.keys)[indexPath.section]]!
        print(dictionaryFrancaisAnglais[Array(dictionaryFrancaisAnglais.keys)[indexPath.section]]!)
        print(dictionaryFrancaisAnglais[Array(dictionaryFrancaisAnglais.keys)[indexPath.section]]!["chat"] as Any)
        
        
        //print(dictionaryFrancaisAnglais[Array(dictionaryFrancaisAnglais.keys)[indexPath.section]]!["chien"]!)
        
        // cell.textLabel!.text = dictionaryFrancaisAnglais[Array(dictionaryFrancaisAnglais.keys)[indexPath.section]]?[indexPath.row]
        //cell.textLabel!.text = motRecherche[Array(motRecherche.keys)[indexPath.section]]?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dictionaryFrancaisAnglais[Array(dictionaryFrancaisAnglais.keys)[section]]?.count)!
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictionaryFrancaisAnglais.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(dictionaryFrancaisAnglais.keys)[section]
    }
}

