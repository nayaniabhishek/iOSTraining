//
//  SettingsViewController.swift
//  Tippy
//
//  Created by Abhishek Nayani on 9/24/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tipControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "defaultTip")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTipChange(_ sender: UISegmentedControl) {
        let defaults = UserDefaults.standard
        defaults.set(tipControl.selectedSegmentIndex, forKey: "defaultTip")
        defaults.synchronize()
    }
}
