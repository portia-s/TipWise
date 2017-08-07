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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight > 570 && screenHeight < 730 {
            print("Screen Height -> ", screenHeight)
            amountTextField.font = UIFont(name: "Avenir Next Condensed", size: 80)
        }
        else {
            if screenHeight > 730 {
                print("Screen Height -> ", screenHeight)
                amountTextField.font = UIFont(name: "Avenir Next Condensed", size: 120)
        }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        //keyboard appears when app launches and billAmount textfield ready to take input
        amountTextField.becomeFirstResponder()
        self.amountTextField.delegate = self
        //pickerDatasource & Delegate declaration
        partySizePicker.dataSource = self
        partySizePicker.delegate = self
        partySizePicker.selectedRow(inComponent: 0) //initial set to 1person inn party
//        //billView height animations setup
        billViewHeightConstraint.constant = 400
        billView.layoutIfNeeded()
        amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //to obtain keyboard height
        NotificationCenter.default.addObserver(self, selector: #selector(TipViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //tipValueControl.selectedSegmentIndex[3] = readFromNSUD().0
        let myCustomTipPercent = Int(readFromNSUD().0 * 100)
        tipValueControl.setTitle("\(myCustomTipPercent)%", forSegmentAt: 3)
        let tipPercent = [0.10, 0.15, 0.20, Double(readFromNSUD().0)]
        
        //make certain billAmnt is valid double in case TF is nil then default is 0
        let billAmount = Double(amountTextField.text!) ?? 0.00
        let tipAmount = billAmount * tipPercent[tipValueControl.selectedSegmentIndex]
        let totalAmount = billAmount + tipAmount
        totalBillWithTip = totalAmount
        let splitLabelValue = (totalAmount / Double(partySize)!)
        splitLabel.text = String(format: "$%0.2f", splitLabelValue)
        
        if readFromNSUD().1 == true {
            tipLabel.text = String(format: "$%0.2f", tipAmount)
            totalLabel.text = String(format: "$%0.2f", totalAmount)
            splitLabel.text = String(format: "$%0.2f", splitLabelValue)
        }
        else {
            tipLabel.text = String(format: "$%0.0f", tipAmount)
            totalLabel.text = String(format: "$%0.0f", totalAmount)
            splitLabel.text = String(format: "$%0.0f", splitLabelValue)
        }
        
        //splitLabel.text = internalSplitCalculation(text: partySizetextField.text!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //dismiss keyboard of textfields on view tap
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //calculate tip when amtTF and/or tipSeg change values
    @IBAction func calculateTip(_ sender: AnyObject) {
        
        let tipPercent = [0.10, 0.15, 0.20, Double(readFromNSUD().0)]
        
        //make certain billAmnt is valid double in case TF is nil then default is 0
        let billAmount = Double(amountTextField.text!) ?? 0.00
        let tipAmount = billAmount * tipPercent[tipValueControl.selectedSegmentIndex]
        let totalAmount = billAmount + tipAmount
        totalBillWithTip = totalAmount
        let splitLabelValue = (totalAmount / Double(partySize)!)
        splitLabel.text = String(format: "$%0.2f", splitLabelValue)
        
        
        if readFromNSUD().1 == true {
            tipLabel.text = String(format: "$%0.2f", tipAmount)
            totalLabel.text = String(format: "$%0.2f", totalAmount)
            splitLabel.text = String(format: "$%0.2f", splitLabelValue)
        }
        else {
            tipLabel.text = String(format: "$%0.0f", tipAmount)
            totalLabel.text = String(format: "$%0.0f", totalAmount)
            splitLabel.text = String(format: "$%0.0f", splitLabelValue)
        }
        //No split rounding earlier
        //splitLabel.text = internalSplitCalculation(text: partySizetextField.text!)
        
    }
    
//    @IBAction func calculateSplit(_ sender: UITextField) {
//        splitLabel.text = internalSplitCalculation(text: sender.text!)
//    }
    
    func splitCalculation(text: String) -> String {
        if text != "0" {
            let splitNumber = Double(text) ?? 1.0
            let splitAmount = totalBillWithTip/splitNumber
            if readFromNSUD().1 == true {
                return String(format: "$%0.2f", splitAmount)
            }
            else {
                return String(format: "$%0.0f", splitAmount)
            }
        }
        return "NA"
    }
    
    //Textfield delegate for decimal point and places
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
    
    func readFromNSUD() -> (Double, Bool, Int, Double) {
        let defaultsW = UserDefaults.standard
        let cTipValueR = defaultsW.double(forKey: "myCustomTipValueKey")
        let decimalTipEnableR = defaultsW.bool(forKey: "myDecimalTipEnableKey")
        let roundSplitIndexR = defaultsW.integer(forKey: "myRoundSplitIndexKey")
        let versionR = defaultsW.double(forKey: "myVersionKey")
        return (cTipValueR, decimalTipEnableR, roundSplitIndexR, versionR)
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
    
    //func for checking if amount field has value
    func textFieldDidChange(_ amount: UITextField) {
        if amount.text == nil || amount.text == "" {
            UIView.animate(withDuration: 0.2, animations: {
                self.billViewHeightConstraint.constant = CGFloat(Int(self.screenHeight) - Int(self.keyBoardHeight))
                self.billView.superview?.layoutIfNeeded()
            })
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.billViewHeightConstraint.constant = CGFloat(Int(self.screenHeight) - Int(self.keyBoardHeight) - 28 - 8 - 8 - 96 - 110 - 20)
                self.billView.superview?.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyBoardHeight = Float(keyboardRectangle.height)
            
            screenHeight = Float(UIScreen.main.bounds.height)
            textFieldDidChange(amountTextField)
            //billView height animations setup
//            billViewHeightConstraint.constant = CGFloat(Int(screenHeight) - Int(keyBoardHeight) - 28 - 8 - 8 - 96 - 110 - 20)
//            print(keyBoardHeight, screenHeight)
//            billView.layoutIfNeeded()

        }
    }
}


