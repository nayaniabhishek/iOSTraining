//
//  ViewController.swift
//  Tippy
//
//  Created by Abhishek Nayani on 9/23/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var displayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTextField.becomeFirstResponder()
        
        let defaults = UserDefaults.standard
        
        let prevBillAmt = defaults.float(forKey: "lastBillAmount")
        
        if (prevBillAmt != 0.0) {
            let timestamp = defaults.double(forKey: "lastBillTime")
            let now = NSDate().timeIntervalSince1970
            if (now < (timestamp + (60 * 10))) {
                amountTextField.text = String(format: "%.2f", prevBillAmt)
                self.displayView.isHidden = false
                self.tipControl.isHidden = false
                updateView()
            } else {
                defaults.removeObject(forKey: "lastBillAmount")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTextChange(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.4, animations: {
            // This causes first view to fade in and second view to fade out
            if (self.amountTextField.text?.isEmpty)! {
                self.displayView.isHidden = true
                self.tipControl.isHidden = true
            } else {
                self.displayView.isHidden = false
                self.tipControl.isHidden = false
            }
        })
        updateView()
    }
    
    
    
    @IBAction func onTipChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    @IBAction func onTapAction(_ sender: UITapGestureRecognizer) {
        amountTextField.endEditing(true)
    }
    
    func updateView() {
        let tipPercentages = [0.15, 0.2, 0.25]
        let bill = Double(amountTextField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        
        let total = bill + tip
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        
        let locale = NSLocale.current
        currencyFormatter.locale = locale as Locale!
        
        tipLabel.text = currencyFormatter.string(from: NSNumber(value:tip))
        totalLabel.text = currencyFormatter.string(from: NSNumber(value:total))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tipControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "defaultTip")
        updateView()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(amountTextField.text, forKey: "lastBillAmount")
        defaults.set(NSDate().timeIntervalSince1970, forKey: "lastBillTime")
        defaults.synchronize()
    }
}

