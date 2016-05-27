//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by trieulieuf9 on 5/16/16.
//  Copyright © 2016 trieulieuf9. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var themeNameLabel: UILabel!
    
    @IBOutlet weak var segmentTextField1: UITextField!
    @IBOutlet weak var segmentTextField2: UITextField!
    @IBOutlet weak var segmentTextField3: UITextField!
    
    var choosenThemeLabel = UILabel()
    var themeDropdownList = UITableView()
    
    var themeName = ["Dark", "Bright", "Colorful"]
    var tempThemeName = "Dark"  // store theme name, before user press save changes
    
    // Vietnamese currency label
    var VNDCurrencyLabel = UILabel()
    var currencySwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up button
        let saveChangesButton = UIButton(frame: CGRectMake(self.view.frame.width / 2 - 75,
                                                        self.view.frame.height - 85, 150, 30))
        saveChangesButton.setTitle("Save Changes", forState: .Normal)
        saveChangesButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        saveChangesButton.addTarget(self, action: #selector(SettingsViewController.saveChangesButtonTouched), forControlEvents: .TouchUpInside)
        
        // add gesture recognizer to UIView
        let onTap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.onTap))
        onTap.cancelsTouchesInView = false // leave room for detecting other touches too
        self.view.addGestureRecognizer(onTap)
        self.view.addSubview(saveChangesButton)
        
        setUpChoosenThemeLabel()
        setUpVNDCurrencySetting()
        // fill settings options with default values
        fillValueToSettingsScreen()
    }
    
    override func viewWillAppear(animated: Bool) {
        // fill settings options with default values
        fillValueToSettingsScreen()
    }

    func saveChangesButtonTouched(){
        //let defaults = NSUserDefaults.standardUserDefaults()
        //let stringValue = defaults.objectForKey("some_key_that_you_choose") as! String
        //let intValue = defaults.integerForKey("another_key_that_you_choose")
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setInteger(Int(segmentTextField1.text!)!, forKey: "segment1")
        defaults.setInteger(Int(segmentTextField2.text!)!, forKey: "segment2")
        defaults.setInteger(Int(segmentTextField3.text!)!, forKey: "segment3")
        
        defaults.setObject(tempThemeName, forKey: "theme")
        
        defaults.setBool(currencySwitch.on, forKey: "vnd_currency")
        
        defaults.setBool(true, forKey: "is_setting_changed")
        
        defaults.synchronize()
        smallToast()
    }
    
    func fillValueToSettingsScreen(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // it will always be true after the first time user Save Settings
        // if there is no value stored. return false
        let isSettingsChanged = defaults.boolForKey("is_setting_changed")
        
        if (isSettingsChanged){
            let segment1 = defaults.integerForKey("segment1")
            let segment2 = defaults.integerForKey("segment2")
            let segment3 = defaults.integerForKey("segment3")
            
            let theme = defaults.objectForKey("theme") as! String
            let onOff = defaults.boolForKey("vnd_currency")
            
            segmentTextField1.text = String(segment1)
            segmentTextField2.text = String(segment2)
            segmentTextField3.text = String(segment3)
            
            choosenThemeLabel.text = theme
            currencySwitch.setOn(onOff, animated: true)
        }else{  // initial settings
            segmentTextField1.text = "18"
            segmentTextField2.text = "20"
            segmentTextField3.text = "22"
            
            choosenThemeLabel.text = "Colorful"
            currencySwitch.setOn(false, animated: true)
        }
    }
    
    func smallToast(){
        let toastLabel = UILabel(frame: CGRectMake(self.view.frame.width/2 - 30,
            self.view.frame.height / 2, 60, 40))
        toastLabel.backgroundColor = UIColor.blackColor()
        toastLabel.textColor = UIColor.whiteColor()
        toastLabel.textAlignment = NSTextAlignment.Center;
        self.view.addSubview(toastLabel)
        toastLabel.text = "Saved"
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        //self.firstView.alpha = 0
        //self.secondView.alpha = 1
        UIView.animateWithDuration(2, animations: {
            toastLabel.alpha = 0
        })
    }
    
    // user click everywhere on the screen to get rid of numpad
    func onTap(){
        self.view.endEditing(true)
    }
    
    func onTap1(){
        setUpThemeDropdownList()
    }
    
    func setUpChoosenThemeLabel(){
        choosenThemeLabel.frame = CGRectMake(self.view.frame.width - 100, 184, 80, 30);
        choosenThemeLabel.textColor = UIColor.blueColor()
        
        let onTap1 = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.onTap1))
        choosenThemeLabel.addGestureRecognizer(onTap1)
        choosenThemeLabel.userInteractionEnabled = true
        
        self.view.addSubview(choosenThemeLabel)
    }
    
    func setUpThemeDropdownList(){
        themeDropdownList.frame = CGRectMake(self.view.frame.width - 115, 212, 95, 150);
        //themeDropdownList.layer.borderWidth = 2.0
        
        themeDropdownList.delegate = self
        themeDropdownList.dataSource = self
        themeDropdownList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(themeDropdownList)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = themeName[indexPath.row]
        //cell.layer.borderWidth = 1.0
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{ // Dark
            choosenThemeLabel.text = "Dark"
            tempThemeName = "Dark"
            themeDropdownList.removeFromSuperview()
        }else if indexPath.row == 1{ // bright
            choosenThemeLabel.text = "Bright"
            tempThemeName = "Bright"
            themeDropdownList.removeFromSuperview()
        }else{ // colorful
            choosenThemeLabel.text = "Colorful"
            tempThemeName = "Colorful"
            themeDropdownList.removeFromSuperview()
        }
    }
    
    func setUpVNDCurrencySetting(){
        // label
        VNDCurrencyLabel.frame = CGRectMake(20, 240, 120, 30);
        VNDCurrencyLabel.text = "VND Currency"
        self.view.addSubview(VNDCurrencyLabel)
        
        // switch 
        currencySwitch.frame = CGRectMake(self.view.frame.width - 100, 240, 60, 30);
        currencySwitch.on = false
        currencySwitch.setOn(true, animated: false);
        currencySwitch.addTarget(self, action: #selector(SettingsViewController.switchValueDidChange), forControlEvents: .ValueChanged);
        self.view.addSubview(currencySwitch);
    }
    
    func switchValueDidChange(sender:UISwitch){
        print(sender.on)
    }
    
    
}
