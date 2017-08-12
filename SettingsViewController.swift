//
//  SettingsViewController.swift
//  TipWise
//
//  Created by Portia Sharma on 8/5/17.
//  Copyright © 2017 Portia Sharma. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

   
    @IBOutlet weak var customTipValueLabel: UILabel!
    @IBOutlet weak var customTipValueSlider: UISlider!
    @IBOutlet weak var decimalTipSwitch: UISwitch!
    //@IBOutlet weak var roundSplitControl: UISegmentedControl!
    @IBOutlet weak var themeSelector: UISegmentedControl!
    @IBOutlet weak var currencySelector: UISegmentedControl!
    
    @IBOutlet weak var customTipLabel: UILabel!
    @IBOutlet weak var decimalTipLabel: UILabel!
    //@IBOutlet weak var roundSplitLabel: UILabel!
    @IBOutlet weak var themesLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    //outlets for theme
    @IBOutlet weak var customTipView: UIView!
    @IBOutlet weak var decimalTipView: UIView!
    @IBOutlet weak var themeView: UIView!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet var settingsView: UIView!
    
    
    //preset values for settings or load user set values
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //customization of labels for this sVC
        customTipLabel.font = UIFont(name: "Avenir Next Condensed", size: 15)
        decimalTipLabel.font = UIFont(name: "Avenir Next Condensed", size: 15)
        //roundSplitLabel.font = UIFont(name: "Avenir Next Condensed", size: 15)
        themesLabel.font = UIFont(name: "Avenir Next Condensed", size: 15)
        currencyLabel.font = UIFont(name: "Avenir Next Condensed", size: 15)
        
        //app is run for first time :: save new values
        let userSettings = readFromNSUD()
        if userSettings.3 == 0.0 {
            customTipValueLabel.text = "0"
            customTipValueSlider.value = 0.0
            decimalTipSwitch.isOn = false
            //roundSplitControl.selectedSegmentIndex = 0
            saveToNSUD(cTipValue: 0.0, decimalTipEnable: false, roundSplitIndex: 2, version: 1.0, themeSelected: 2, currencySelected: 0)
        }
        else {
            let tipPercentR = 100 * userSettings.0
            customTipValueLabel.text = "/(tipPercentR)"
            customTipValueSlider.value = Float(tipPercentR)
            decimalTipSwitch.isOn = userSettings.1
            //roundSplitControl.selectedSegmentIndex = readFromNSUD().2
            themeSelector.selectedSegmentIndex = userSettings.4
            currencySelector.selectedSegmentIndex = userSettings.5
        }
    }
    
    //load NSUD to user values
    override func viewWillAppear(_ animated: Bool) {
        let userSettings = readFromNSUD()
        let tipPercentR = Int(100 * userSettings.0)
        customTipValueLabel.text = "\(tipPercentR)%"
        customTipValueSlider.value = Float(tipPercentR)
        decimalTipSwitch.isOn = userSettings.1
        //roundSplitControl.selectedSegmentIndex = userSettings.2
        themeSelector.selectedSegmentIndex = userSettings.4
        setTheme(selectedThemeSelectorValue: userSettings.4)
        currencySelector.selectedSegmentIndex = userSettings.5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveToNSUD(cTipValue: Double, decimalTipEnable: Bool, roundSplitIndex: Int, version: Double, themeSelected: Int, currencySelected: Int) {
        let defaultsW = UserDefaults.standard
        defaultsW.set(cTipValue, forKey: "myCustomTipValueKey")
        defaultsW.set(decimalTipEnable, forKey: "myDecimalTipEnableKey")
        defaultsW.set(roundSplitIndex, forKey: "myRoundSplitIndexKey")
        defaultsW.set(version, forKey: "myVersionKey")
        defaultsW.set(themeSelected, forKey: "mySelectedThemeKey")
        defaultsW.set(currencySelected, forKey: "mySelectedCurrencyKey")
        defaultsW.synchronize()
    }
    
    func readFromNSUD() -> (Double, Bool, Int, Double, Int, Int) {
        let defaultsR = UserDefaults.standard
        let cTipValueR = defaultsR.double(forKey: "myCustomTipValueKey")
        let decimalTipEnableR = defaultsR.bool(forKey: "myDecimalTipEnableKey")
        let roundSplitIndexR = defaultsR.integer(forKey: "myRoundSplitIndexKey")
        let versionR = defaultsR.double(forKey: "myVersionKey")
        let themeSelectedR = defaultsR.integer(forKey: "mySelectedThemeKey")
        let currencySelectedR = defaultsR.integer(forKey: "mySelectedCurrencyKey")
        return (cTipValueR, decimalTipEnableR, roundSplitIndexR, versionR, themeSelectedR, currencySelectedR)
    }
    
    @IBAction func customTipValueSliderValueChanged(_ sender: UISlider) {
        let customTipPercent = Int(customTipValueSlider.value)
        let customTipFraction = Double(customTipPercent)/100.0
        customTipValueLabel.text = "\(customTipPercent)%"
        let userSettings = readFromNSUD()
        saveToNSUD(cTipValue: customTipFraction, decimalTipEnable: userSettings.1, roundSplitIndex: userSettings.2, version: userSettings.3, themeSelected: userSettings.4, currencySelected: userSettings.5)
    }
    
    @IBAction func decimalTipSwitchValueChanged(_ sender: UISwitch) {
        let userSettings = readFromNSUD()
        let decimalSwitchValue = decimalTipSwitch.isOn
        saveToNSUD(cTipValue: userSettings.0, decimalTipEnable: decimalSwitchValue, roundSplitIndex: userSettings.2, version: userSettings.3, themeSelected: userSettings.4, currencySelected: userSettings.5)
    }
    
    @IBAction func currencySelectorValueChanged(_ sender: UISegmentedControl) {
        let userSettings = readFromNSUD()
        //let currencyCodesAvailable = ["USD", "GBP", "EUR", "JPY", "AUD"]
        //let currencyCodeSelected = currencyCodesAvailable[currencySelector.selectedSegmentIndex]
        //print("selectedCurrencyCode:", currencyCodeSelected)
        saveToNSUD(cTipValue: userSettings.0, decimalTipEnable: userSettings.1, roundSplitIndex: userSettings.2, version: userSettings.3, themeSelected: userSettings.4, currencySelected: currencySelector.selectedSegmentIndex)
    }

    @IBAction func themeSelectorValueChanged(_ sender: UISegmentedControl) {
        setTheme(selectedThemeSelectorValue: themeSelector.selectedSegmentIndex)
        let userSettings = readFromNSUD()
        saveToNSUD(cTipValue: userSettings.0, decimalTipEnable: userSettings.1, roundSplitIndex:userSettings.2, version: userSettings.3, themeSelected: themeSelector.selectedSegmentIndex, currencySelected: userSettings.5)
    }

/*
    @IBAction func roundSplitControlSegmentValueChanged(_ sender: UISegmentedControl) {
        let selectedValue = roundSplitControl.selectedSegmentIndex
        saveToNSUD(cTipValue: readFromNSUD().0, decimalTipEnable: readFromNSUD().1, roundSplitIndex: selectedValue, version: readFromNSUD().3)
}
*/
    func setTheme(selectedThemeSelectorValue: Int) {
        switch selectedThemeSelectorValue {
        case 0:
            navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0x5E8C61)
            settingsView.backgroundColor = UIColor(rgb: 0x72BDA3)
            customTipView.backgroundColor = UIColor(rgb: 0x9FFFCB)
            decimalTipView.backgroundColor = UIColor(rgb: 0x004E64)
            themeView.backgroundColor = UIColor(rgb: 0x9FFFCB)
            currencyView.backgroundColor = UIColor(rgb: 0x004E64)
            //customTipLabel.textColor = UIColor.darkText
            //decimalTipLabel.textColor = UIColor.darkText
            //roundSplitLabel.font = UIFont(name: "Avenir Next Condensed", size: 15)
            themesLabel.textColor = UIColor.darkText
            //currencyLabel.textColor = UIColor.darkText
            themeSelector.tintColor = UIColor(rgb: 0x007AFF)    //default apple blue
            
        case 1:
            navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0xE0479E)
            settingsView.backgroundColor = UIColor(rgb: 0xFFAFC5)
            customTipView.backgroundColor = UIColor(rgb: 0xFFCFD2)
            decimalTipView.backgroundColor = UIColor(rgb: 0x553E4E)
            themeView.backgroundColor = UIColor(rgb: 0xFFCFD2)
            currencyView.backgroundColor = UIColor(rgb: 0x553E4E)
            //customTipLabel.textColor = UIColor.darkText
            //decimalTipLabel.textColor = UIColor.darkText
            //roundSplitLabel.font = UIFont(name: "Avenir Next Condensed", size: 15)
            themesLabel.textColor = UIColor.darkText
            //currencyLabel.textColor = UIColor.darkText
            themeSelector.tintColor = UIColor(rgb: 0x007AFF)    //default apple blue
            
        case 2:
            navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0x443730)
            settingsView.backgroundColor = UIColor(rgb: 0x786452)
            customTipView.backgroundColor = UIColor(rgb: 0xA5907E)
            decimalTipView.backgroundColor = UIColor(rgb: 0x550C18)
            themeView.backgroundColor = UIColor(rgb: 0xA5907E)
            currencyView.backgroundColor = UIColor(rgb: 0x550C18)
            customTipLabel.textColor = UIColor.darkText
            customTipValueLabel.textColor = UIColor.darkText
            //decimalTipLabel.textColor = UIColor.darkText
            //roundSplitLabel.font = UIFont(name: "Avenir Next Condensed", size: 15)
            themesLabel.textColor = UIColor.lightText
            //currencyLabel.textColor = UIColor.darkText
            themeSelector.tintColor = UIColor.white

        default: break
        }
    }

}


//extension for UIColor to take hex input for custom colors
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
