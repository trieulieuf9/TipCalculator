//
//  ViewController.swift
//  TipCalculator
//
//  Created by trieulieuf9 on 5/15/16.
//  Copyright © 2016 trieulieuf9. All rights reserved.
//

// What to do Next

// Choose from Vietnamese and English, radio button

import UIKit

class ViewController: UIViewController {
    
    var total:Double = 0
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var tipControl: UISegmentedControl!

    @IBOutlet weak var billField: UITextField!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    var tipPercentages:[Double] = []
    
    // Create UIComponents programmatically
    var eachPeopleBillLabel:UILabel = UILabel()
    
    var slider:UISlider = UISlider()
    
    //currency - VND or US
    var isVND = false  // default will be US Dollar
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        // it will always be true, since the first time user Save Settings
        // if there is no value stored. return false
        
        let isSettingsChanged = defaults.boolForKey("is_setting_changed")
        
        if (isSettingsChanged){
            let segment1 = defaults.integerForKey("segment1")
            let segment2 = defaults.integerForKey("segment2")
            let segment3 = defaults.integerForKey("segment3")
            tipPercentages = [Double(segment1) / 100,
                              Double(segment2) / 100,
                              Double(segment3) / 100]
            
            tipControl.setTitle("\(segment1)%", forSegmentAtIndex: 0)
            tipControl.setTitle("\(segment2)%", forSegmentAtIndex: 1)
            tipControl.setTitle("\(segment3)%", forSegmentAtIndex: 2)
            
            let theme = defaults.objectForKey("theme") as! String
            changeTheme(theme)
            
            isVND = defaults.boolForKey("vnd_currency") // return false --> USD, true --> VND
        }else{  // initial settings
            tipPercentages = [0.18, 0.2, 0.22]
            isVND = false
        }
        
        setUpeachPeopleBillLabel()
        setUpSlider()
        makeBillFieldLookBetter()
    }

    @IBAction func onEditingChange(sender: AnyObject) {
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let billAmount = NSString(string: billField.text!).doubleValue
        let tip = billAmount * tipPercentage
        total = billAmount + tip
        
        if isVND { // VND
            if total > 1000 {
                var mAmount = Int(total / 1000)
                var kAmount = Double(total % 1000)
                
                // get remainder
                // ex: 99.5, get number 5 in this number
                let kRemainder = Int((kAmount - Double(Int(kAmount))) * 10)
                let tipAmountRemainder = Int((tip - Double(Int(tip))) * 10)
                
                totalLabel.text = "\(mAmount)m\(Int(kAmount))k\(kRemainder)"
                if tip > 1000 {
                    mAmount = Int(tip / 1000)
                    kAmount = Double(tip % 1000)
                    
                    tipLabel.text = "\(mAmount)m\(Int(kAmount))k\(kRemainder)"
                }else{
                    tipLabel.text = "\(Int(tip))k\(tipAmountRemainder)"
                    //tipLabel.text = String(format: "%.1fk", tip)
                }
            }else{
                let tipAmountRemainder = Int((tip - Double(Int(tip))) * 10)
                let totalAmountRemainder = Int((total - Double(Int(total))) * 10)
                
                tipLabel.text = "\(Int(tip))k\(tipAmountRemainder)"
                totalLabel.text = "\(Int(total))k\(totalAmountRemainder)"
                
                //tipLabel.text = String(format: "%.1fk", tip)
                //totalLabel.text = String(format: "%.1fk", total)
            }
            
        }else{ // $
            tipLabel.text = String(format: "$%.2f", tip)
            totalLabel.text = String(format: "$%.2f", total)
        }
        
        // update bill for each people
        sliderValueDidChange(slider)
    }
    
    // when user tap anywhere in the screen, close the iphone numPad
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // Make the billField look better
    func makeBillFieldLookBetter(){
        var frameRect = billField.frame;
        frameRect.size.height = 120;
        
        billField.frame = frameRect;
        billField.font = UIFont(name: "Arial", size: 85)
        billField.textColor = UIColor(red: 0.2, green: 0.55, blue: 0.2, alpha: 1.0)
        billField.becomeFirstResponder()
        billField.textAlignment = .Right
        billField.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.3, alpha: 1.0)
        if isVND {
            billField.placeholder = "VND"
        }else{
            billField.placeholder = "$"
        }
    }
    
    // Set Up UI Stuffs here
    func setUpeachPeopleBillLabel(){
        eachPeopleBillLabel.frame = CGRectMake(0,
            self.view.frame.height - 160, self.view.frame.width, 30)
        eachPeopleBillLabel.font = UIFont(name: "Arial", size: 28)
        
        eachPeopleBillLabel.textAlignment = .Center
        //eachPeopleBillLabel.textColor = UIColor.blackColor()
        self.view.addSubview(eachPeopleBillLabel)
    }
    
    func setUpSlider(){
        slider.frame = CGRectMake(20, self.view.frame.height - 70,
                                  self.view.frame.width - 40 ,20)
        slider.minimumValue = 1
        slider.maximumValue = 20
        slider.continuous = true
        slider.tintColor = UIColor.redColor()
        slider.value = 4
        slider.addTarget(self, action: #selector(ViewController.sliderValueDidChange), forControlEvents: .ValueChanged)
        self.view.addSubview(slider)
    }
    
    func sliderValueDidChange(slider:UISlider){
        let numberOfPeople = Int(slider.value)
        let billForEach = Int(total) / numberOfPeople
        if isVND {  // vnd
            if billForEach > 1000 {
                let mAmount = billForEach / 1000
                let kAmount = billForEach % 1000
                let formattedString = "\(mAmount)m\(kAmount)k"
                eachPeopleBillLabel.text = "\(numberOfPeople) 👫: \(formattedString) For Each"
            }else{
                eachPeopleBillLabel.text = "\(numberOfPeople) 👫: \(billForEach)k For Each"
            }
        }else{  // dollar
            eachPeopleBillLabel.text = "\(numberOfPeople) 👫: $\(billForEach) For Each"
        }
    }
    
    func changeTheme(themeName:String){
        if themeName == "Dark"{
            self.view.backgroundColor = UIColor.blackColor()
            billField.backgroundColor =
                UIColor(red: 39/255, green: 59/255, blue: 59/255, alpha: 1.0)
            
            changeTextColor(UIColor.grayColor())
            eachPeopleBillLabel.textColor = UIColor.grayColor()
            slider.tintColor = UIColor.grayColor()
        }else if themeName == "Bright"{
            self.view.backgroundColor = UIColor.whiteColor()
            billField.backgroundColor =
                UIColor(red: 235/255, green: 235/255, blue: 250/255, alpha: 1.0)
            slider.tintColor = UIColor.redColor()
            tipControl.tintColor = UIColor.blackColor()
            changeTextColor(UIColor.blackColor())
            
        }else{  // colorful
            self.view.backgroundColor =
                UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1.0)
            billField.backgroundColor =
                UIColor(red: 221/255, green: 160/255, blue: 221/255, alpha: 1.0)
            slider.tintColor = UIColor.redColor()
            tipControl.tintColor = UIColor.blackColor()
            changeTextColor(UIColor.blackColor())
        }
    }
    
    func changeTextColor(color:UIColor){
        label1.textColor = color
        label2.textColor = color
        tipLabel.textColor = color
        totalLabel.textColor = color
        tipControl.tintColor = color
    }
}