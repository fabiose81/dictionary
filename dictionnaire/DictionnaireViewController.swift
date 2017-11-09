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
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       loadDictionnaire()
    }
    
    func loadDictionnaire()
    {
        if userDefaultsManager.doesKeyExist(theKey: "dictionaryFrancaisAnglais") && userDefaultsManager.doesKeyExist(theKey: "dictionaryAnglaisFrancais")
        {
            dictionaryFrancaisAnglais =  userDefaultsManager.getValue(theKey: "dictionaryFrancaisAnglais") as! [String: [String: String]]
            dictionaryAnglaisFrancais =  userDefaultsManager.getValue(theKey: "dictionaryAnglaisFrancais") as! [String: [String: String]]
            
            print(dictionaryFrancaisAnglais)
            print(dictionaryAnglaisFrancais)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultatRecherche.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:nil)
        cell.textLabel!.text = resultatRecherche[indexPath.row]
        
        return cell
    }

}

