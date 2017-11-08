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
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBOutlet weak var tableViewHistoriqueRecherche: UITableView!
    
    var dictionaryFrancaisAnglais = [String: String]()
    var dictionaryAnglaisFrancais = [String: String]()
    var historiqueRecherche = [String]()
    
    var userDefaultsManager = UserDefaultsManager()
    
    @IBAction func actionTextField1(_ sender: UITextField) {
        traduire(_mot: String(describing: sender.text!).trimmingCharacters(in: .whitespaces))
    }
    
    @IBAction func actionSegControl(_ sender: UISegmentedControl) {
        
        let seg = sender.selectedSegmentIndex
        
        let mot = textField1.text!.trimmingCharacters(in: .whitespaces)
        
        
        if seg == 0
        {
            textField1.placeholder = "Composer le mot en français"
        }
        else
        {
            textField1.placeholder = "Enter the english word"
        }
        
        if mot != ""
        {
            traduire(_mot: mot)
        }
    }
    
    private func traduire(_mot: String)
    {
        let seg = segControl.selectedSegmentIndex
        
        if seg == 0
        {
            for mot in dictionaryFrancaisAnglais{
                if mot.key == _mot{
                    textField2.text = mot.value
                    historiqueRecherche.append("\(mot.key) = \(mot.value)")
                    tableViewHistoriqueRecherche.reloadData()
                    break
                }else{
                    textField2.text = ""
                }
            }
        }
        else
        {
            for mot in dictionaryAnglaisFrancais{
                if mot.key == _mot{
                    textField2.text = mot.value
                    historiqueRecherche.append("\(mot.key) = \(mot.value)")
                    tableViewHistoriqueRecherche.reloadData()
                    break
                }else{
                    textField2.text = ""
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
            dictionaryFrancaisAnglais =  userDefaultsManager.getValue(theKey: "dictionaryFrancaisAnglais") as! [String: String]
            dictionaryAnglaisFrancais =  userDefaultsManager.getValue(theKey: "dictionaryAnglaisFrancais") as! [String: String]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historiqueRecherche.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:nil)
        cell.textLabel!.text = historiqueRecherche[indexPath.row]
        
        return cell
    }

}

