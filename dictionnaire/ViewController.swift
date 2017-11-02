//
//  ViewController.swift
//  dictionnaire
//
//  Created by eleves on 2017-11-02.
//  Copyright © 2017 eleves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    
    var dictionaryFrancaisAnglais = [String: String]()
    var dictionaryAnglaisFrancais = [String: String]()
    
    
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
                    break
                }else{
                    textField2.text = ""
                }
            }
        }

    }
    
    override func viewDidLoad() {
        
        textField1.placeholder = "Composer le mot en français"
        
        segControl.setTitle("Français", forSegmentAt: 0)
        segControl.setTitle("Anglais", forSegmentAt: 1)
        
        dictionaryFrancaisAnglais = ["chien" : "dog", "chat" : "cat" , "souris" : "mouse"]
        dictionaryAnglaisFrancais = ["dog" : "chien", "cat" : "chat" , "mouse" : "souris"]
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

