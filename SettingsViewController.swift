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
    
    @IBOutlet weak var customTipLabel: UILabel!
    @IBOutlet weak var decimalTipLabel: UILabel!
    //@IBOutlet weak var roundSplitLabel: UILabel!
    @IBOutlet weak var themesLabel: UILabel!
    
    
    //preset values for settings or load user set values
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //customization of labels for this sVC
        customTipLabel.font = UIFont(name: "Avenir Next Condensed", size: 15)
        decimalTipLabel.font = UIFont(name: "Avenir Next Condensed", size: 15)
        //roundSplitLabel.font = UIFont(name: "Avenir Next Condensed", size: 15)
        themesLabel.font = UIFont(name: "Avenir Next Condensed", size: 15)
        
        //app is run for first time :: save new values
        if readFromNSUD().3 == 0.0 {
            customTipValueLabel.text = "11"
            customTipValueSlider.value = 11.0
            decimalTipSwitch.isOn = true
            //roundSplitControl.selectedSegmentIndex = 0
            saveToNSUD(cTipValue: 0.11, decimalTipEnable: true, roundSplitIndex: 2, version: 1.0)
        }
        else {
            let tipPercentR = 100 * readFromNSUD().0
            customTipValueLabel.text = "/(tipPercentR)"
            customTipValueSlider.value = Float(tipPercentR)
            decimalTipSwitch.isOn = readFromNSUD().1
            //roundSplitControl.selectedSegmentIndex = readFromNSUD().2
        }
    }
    
    //load NSUD to user values
    override func viewWillAppear(_ animated: Bool) {
        let tipPercentR = Int(100 * readFromNSUD().0)
        customTipValueLabel.text = "\(tipPercentR)%"
        customTipValueSlider.value = Float(tipPercentR)
        decimalTipSwitch.isOn = readFromNSUD().1
        //roundSplitControl.selectedSegmentIndex = readFromNSUD().2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveToNSUD(cTipValue: Double, decimalTipEnable: Bool, roundSplitIndex: Int, version: Double) {
        let defaultsW = UserDefaults.standard
        defaultsW.set(cTipValue, forKey: "myCustomTipValueKey")
        defaultsW.set(decimalTipEnable, forKey: "myDecimalTipEnableKey")
        defaultsW.set(roundSplitIndex, forKey: "myRoundSplitIndexKey")
        defaultsW.set(version, forKey: "myVersionKey")
        defaultsW.synchronize()
    }
    
    func readFromNSUD() -> (Double, Bool, Int, Double) {
        let defaultsW = UserDefaults.standard
        let cTipValueR = defaultsW.double(forKey: "myCustomTipValueKey")
        let decimalTipEnableR = defaultsW.bool(forKey: "myDecimalTipEnableKey")
        let roundSplitIndexR = defaultsW.integer(forKey: "myRoundSplitIndexKey")
        let versionR = defaultsW.double(forKey: "myVersionKey")
        return (cTipValueR, decimalTipEnableR, roundSplitIndexR, versionR)
    }
    
    @IBAction func customTipValueSliderValueChanged(_ sender: UISlider) {
        let customTipPercent = Int(customTipValueSlider.value)
        let customTipFraction = Double(customTipPercent)/100.0
        customTipValueLabel.text = "\(customTipPercent)%"
        saveToNSUD(cTipValue: customTipFraction, decimalTipEnable: readFromNSUD().1, roundSplitIndex: readFromNSUD().2, version: readFromNSUD().3)
    }
    @IBAction func decimalTipSwitchValueChanged(_ sender: UISwitch) {
        let decimalSwitchValue = decimalTipSwitch.isOn
        saveToNSUD(cTipValue: readFromNSUD().0, decimalTipEnable: decimalSwitchValue, roundSplitIndex: readFromNSUD().2, version: readFromNSUD().3)
    }
    /*
    @IBAction func roundSplitControlSegmentValueChanged(_ sender: UISegmentedControl) {
        let selectedValue = roundSplitControl.selectedSegmentIndex
        saveToNSUD(cTipValue: readFromNSUD().0, decimalTipEnable: readFromNSUD().1, roundSplitIndex: selectedValue, version: readFromNSUD().3)
}
*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
