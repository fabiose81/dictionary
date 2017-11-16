//
//  ViewController.swift
//  dictionnaire
//
//  Created by Fabio Estrela on 2017-11-02.
//  Copyright © 2017 Fabio Estrela. All rights reserved.
//

import UIKit

class DictionnaireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var labelResultat: UILabel!
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBOutlet weak var tableViewDictionnaire: UITableView!
    
    var motsFrancais = [String: [String]]()
    var motsAnglais = [String: [String]]()
    
    var dictionnaireFrancaisAnglais = [String: String]()
    var dictionnaireAnglaisFrancais = [String: String]()
    
    var dictionnaireFrancaisAnglaisSorted = [(key: String, value: [String])]()
    var dictionnaireAnglaisFrancaisSorted = [(key: String, value: [String])]()
    
    var userDefaultsManager = UserDefaultsManager()
    
    var segControlSelected = 0
    
    var refreshControl: UIRefreshControl!
   
    @IBAction func actionSegControl(_ sender: UISegmentedControl) {
        segControlSelected = sender.selectedSegmentIndex
        tableViewDictionnaire.reloadData()
    }
    
    override func viewDidLoad() {
        
        viewTop.layer.borderColor = UIColor(rgb: 0x366295).cgColor
        viewTop.layer.borderWidth = 2
        
        tableViewDictionnaire.layer.borderColor = UIColor(rgb: 0x366295).cgColor
        tableViewDictionnaire.layer.borderWidth = 2
        
        refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(DictionnaireViewController.refreshTableView), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Tirer pour rafraîchir")
        tableViewDictionnaire.addSubview(refreshControl)
        
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
    
    func refreshTableView(){
        if userDefaultsManager.doesKeyExist(theKey: "misAJour") {
            let misAJour =  userDefaultsManager.getValue(theKey: "misAJour") as! Bool
            if misAJour
            {
                loadDictionnaire()
                userDefaultsManager.setKey(theValue: false as Bool as AnyObject, key: "misAJour")
                tableViewDictionnaire.reloadData()
            }
            refreshControl.endRefreshing()
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
       
        headerView.backgroundColor = UIColor(rgb: 0x366295)
        
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: tableView.bounds.size.width, height: 30))
        label.textColor = UIColor.white
        
        if segControlSelected == 0
        {
             label.text = dictionnaireFrancaisAnglaisSorted[section].key
        }
        else
        {
           label.text = dictionnaireAnglaisFrancaisSorted[section].key
        }
        
        headerView.addSubview(label)
       
        return headerView
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

