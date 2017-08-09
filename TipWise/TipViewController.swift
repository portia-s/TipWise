//
//  TipViewController.swift
//  TipWise
//
//  Created by Portia Sharma on 8/5/17.
//  Copyright © 2017 Portia Sharma. All rights reserved.
//

import UIKit

class TipViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var partySizePicker: UIPickerView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var tipValueControl: UISegmentedControl!
    
    @IBOutlet weak var billView: UIView!
    @IBOutlet weak var billViewHeightConstraint: NSLayoutConstraint!
    
    var totalBillWithTip = Double()
    let partySizePickerData = ["1", "2","3", "4", "5", "6", "7", "8", "9", "10","11", "12", "13", "14", "15", "16", "17", "18","19", "20"]
    var partySize = "1"
    
    var keyBoardHeight = Float()
    var screenHeight = Float()
    var runOnce = true
    
    var myFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenHeight = Float(UIScreen.main.bounds.height)
        print("ScreenHeight in ViewDidLoad -> ", screenHeight)
        //to obtain keyboard height
        NotificationCenter.default.addObserver(self, selector: #selector(TipViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        print("Keyboard Observer in ViewDidLoad")
        
        // billAmnt font resizing based on device defaultSize 50
        if screenHeight > 570 && screenHeight < 730 {
            amountTextField.font = UIFont(name: "Avenir Next Condensed", size: 70)
        }
        else {
            if screenHeight > 730 {
                amountTextField.font = UIFont(name: "Avenir Next Condensed", size: 120)
            }
        }
        
        //keyboard appears when app launches and billAmount textfield ready to take input
        amountTextField.delegate = self
        amountTextField.becomeFirstResponder()
        amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        print("Amount TextField First Responder in ViewDidLoad")
        
        //pickerDatasource & Delegate declaration
        partySizePicker.dataSource = self
        partySizePicker.delegate = self
        partySizePicker.selectedRow(inComponent: 0) //initial set to 1person in party
        
        print("Picker Delegate in ViewDidLoad")
        
        print("Screen & Keyboard Heights -> ", screenHeight, keyBoardHeight)
        //reload billamnt if app restarted <10min otherwise nilAmnt
        if billAmnt_g != nil {
            print("billAmnt from NSUserDefaults in ViewDidLoad -> ", billAmnt_g)
            amountTextField.text = "\(billAmnt_g!)"
            calculateTip(self)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //setup money fields according to currency chosen
        
        myFormatter.numberStyle = NumberFormatter.Style.currency
        switch readFromNSUD().5 {
        case 0:
            myFormatter.locale = Locale(identifier: "en_US")
        case 1:
            myFormatter.locale = Locale(identifier: "en_GB")
        case 2:
            myFormatter.locale = Locale(identifier: "fr_FR")
        case 3:
            myFormatter.locale = Locale(identifier: "ja_JP")
        case 4:
            myFormatter.locale = Locale(identifier: "au_AU")
        default:
            myFormatter.locale = Locale(identifier: "ja_JP")
        }
        
        
        //tipValueControl.selectedSegmentIndex[3] = readFromNSUD().0
        let myCustomTipPercent = Int(readFromNSUD().0 * 100)
        tipValueControl.setTitle("\(myCustomTipPercent)%", forSegmentAt: 3)
        let tipPercent = [0.10, 0.15, 0.20, Double(readFromNSUD().0)]
        
        //make certain billAmnt is valid double, in case TF is nil then default is 0
        let billAmount = Double(amountTextField.text!) ?? 0.00
        let tipAmount = billAmount * tipPercent[tipValueControl.selectedSegmentIndex]
        let totalAmount = billAmount + tipAmount
        totalBillWithTip = totalAmount
        let splitLabelValue = (totalAmount / Double(partySize)!)
        //splitLabel.text = String(format: "$%0.2f", splitLabelValue)
        splitLabel.text = myFormatter.string(from: splitLabelValue as NSNumber)
        
        if readFromNSUD().1 == true {
            myFormatter.maximumFractionDigits = 2
            tipLabel.text = myFormatter.string(from: tipAmount as NSNumber)
            totalLabel.text = myFormatter.string(from: totalAmount as NSNumber)
            splitLabel.text = myFormatter.string(from: splitLabelValue as NSNumber)
        }
        else {
            myFormatter.maximumFractionDigits = 0
            tipLabel.text = myFormatter.string(from: tipAmount as NSNumber)
            totalLabel.text = myFormatter.string(from: totalAmount as NSNumber)
            splitLabel.text = myFormatter.string(from: splitLabelValue as NSNumber)
        }
        
        //splitLabel.text = internalSplitCalculation(text: partySizetextField.text!)
        
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //dismiss keyboard of textfields on view tap
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        //view.endEditing(true)
    }
    
    //calculate tip when amtTF and/or tipSeg change values
    @IBAction func calculateTip(_ sender: AnyObject) {
        
        let tipPercent = [0.10, 0.15, 0.20, Double(readFromNSUD().0)]
        
        //make certain billAmnt is valid double, in case TF is nil then default is 0
        let billAmount = Double(amountTextField.text!) ?? 0.00
        let tipAmount = billAmount * tipPercent[tipValueControl.selectedSegmentIndex]
        let totalAmount = billAmount + tipAmount
        totalBillWithTip = totalAmount
        let splitLabelValue = (totalAmount / Double(partySize)!)
        //splitLabel.text = String(format: "$%0.2f", splitLabelValue)
        splitLabel.text = myFormatter.string(from: splitLabelValue as NSNumber)
        
        
        if readFromNSUD().1 == true {
            tipLabel.text = myFormatter.string(from: tipAmount as NSNumber)
            totalLabel.text = myFormatter.string(from: totalAmount as NSNumber)
            splitLabel.text = myFormatter.string(from: splitLabelValue as NSNumber)
        }
        else {
            tipLabel.text = myFormatter.string(from: tipAmount as NSNumber)
            totalLabel.text = myFormatter.string(from: totalAmount as NSNumber)
            splitLabel.text = myFormatter.string(from: splitLabelValue as NSNumber)
        }
        //No split rounding earlier
        //splitLabel.text = internalSplitCalculation(text: partySizetextField.text!)
    }
    
    //    //Textfield delegate for decimal point and places
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
        //limit billAmount textfield to two decimal places for input
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let regex = try! NSRegularExpression(pattern: "\\..{3,}", options: [])
        let matches = regex.matches(in: newText, options:[], range:NSMakeRange(0, newText.characters.count))
        guard matches.count == 0 else { return false }
        
        // limit billAmount textfield to allow ONLY one decimal point for input
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true
        case ".":
            let array = Array(textField.text!.characters)
            var decimalCount = 0
            for character in array {
                if character == "." {
                    decimalCount += 1
                }
            }
            
            if decimalCount == 1 {
                return false
            } else {
                return true
            }
        default:
            let array = Array(string.characters)
            if array.count == 0 {
                return true
            }
            return false
        }
    }
    
    func readFromNSUD() -> (Double, Bool, Int, Double, Int, Int) {
        let defaultsW = UserDefaults.standard
        let cTipValueR = defaultsW.double(forKey: "myCustomTipValueKey")
        let decimalTipEnableR = defaultsW.bool(forKey: "myDecimalTipEnableKey")
        let roundSplitIndexR = defaultsW.integer(forKey: "myRoundSplitIndexKey")
        let versionR = defaultsW.double(forKey: "myVersionKey")
        let themeSelectedR = defaultsW.integer(forKey: "mySelectedThemeKey")
        let currencySelectedR = defaultsW.integer(forKey: "mySelectedCurrencyKey")
        return (cTipValueR, decimalTipEnableR, roundSplitIndexR, versionR, themeSelectedR, currencySelectedR)
    }
    
    //PickerView Required Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return partySizePickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return partySizePickerData[row]
    }
    //PickerView method to select partysize and calc split amount to display
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        partySize = partySizePickerData[row]
        splitLabel.text =  splitCalculation(text: partySize)
    }
    func splitCalculation(text: String) -> String {
        if text != "0" {
            let splitNumber = Double(text) ?? 1.0
            let splitAmount = totalBillWithTip/splitNumber
            if readFromNSUD().1 == true {
                return myFormatter.string(from: splitAmount as NSNumber)!
            }
            else {
                return myFormatter.string(from: splitAmount as NSNumber)!
            }
        }
        return "NA"
    }
    
    
    //func to resize the billAmntView to animate tipTotalV & splitV
    func textFieldDidChange(_ amount: UITextField) {
        //track billAmoount to be remembered if app quits
        print("Screen & Keyboard Height in textFieldDidChange ****************-> ", screenHeight, keyBoardHeight)
        billAmnt_g = Double(amount.text!)
        if amount.text == nil || amount.text == "" {
            UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: {
                self.billViewHeightConstraint.constant = CGFloat(Int(self.screenHeight) - Int(self.keyBoardHeight) )
                self.billView.superview?.layoutIfNeeded()
            })
        }
        else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: {
                self.billViewHeightConstraint.constant = CGFloat(Int(self.screenHeight) - Int(self.keyBoardHeight) - 28 - 8 - 8 - 96 - 110 - 20)
                self.billView.superview?.layoutIfNeeded()
            })
            //            if runOnce {
            //                if billAmnt_g != nil {
            //                    amountTextField.text = "\(billAmnt_g!)"
            //                    runOnce = false
            //                    amountTextField.setNeedsLayout()
            //                    amountTextField.layoutIfNeeded()
            //                }
            //            }
        }
        billView.layoutSubviews()
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyBoardHeight = Float(keyboardRectangle.height)
            print("Screen & Keyboard Height in KeyboardWillShow -> ", screenHeight, keyBoardHeight)
            
            screenHeight = Float(UIScreen.main.bounds.height)
            //textFieldDidChange(amountTextField)
            //billAmnt_g = Double(amount.text!)
            if billAmnt_g == nil {
                UIView.animate(withDuration: 0.2, animations: {
                    self.billViewHeightConstraint.constant = CGFloat(Int(self.screenHeight) - Int(self.keyBoardHeight) )
                    self.billView.superview?.layoutIfNeeded()
                })
            }
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.billViewHeightConstraint.constant = CGFloat(Int(self.screenHeight) - Int(self.keyBoardHeight) - 28 - 8 - 8 - 96 - 110 - 20)
                    self.billView.superview?.layoutIfNeeded()
                })
            }
            //billView height animations setup
            //            billViewHeightConstraint.constant = CGFloat(Int(screenHeight) - Int(keyBoardHeight) - 28 - 8 - 8 - 96 - 110 - 20)
            //            print(keyBoardHeight, screenHeight)
            //            billView.layoutIfNeeded()
            
        }
    }
    
    
}


