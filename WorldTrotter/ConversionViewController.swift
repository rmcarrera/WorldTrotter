//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Roxana Carrera on 1/28/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class ConversionViewController : UIViewController, UITextFieldDelegate {
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>?{
        didSet{
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField){
        //celsiusLabel.text = textField.text
        
        //if let text = textField.text, let value = Double(text){
          //  fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        if let text = textField.text, let number = numberFormatter.number(from: text){
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel(){
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController opened its view")
        
        updateCelsiusLabel()
    }
    
    func getRandomColor() -> UIColor{
        let rRed:CGFloat = CGFloat(drand48())
        let rGreen:CGFloat = CGFloat(drand48())
        let rBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: rRed, green: rGreen, blue: rBlue, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //let hour = NSCalendar.current.component(.hour, from: NSDate() as Date)
        view.backgroundColor = getRandomColor()
    }
    
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        //let existingTestHasDecimalSeparator = textField.text?.range(of: ".")
        //let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        let numberAndDecimalInText = string.rangeOfCharacter(from: NSCharacterSet(charactersIn: "0123456789.,") as CharacterSet)
        
        if string.characters.count == 0{
           return true
        }
        
        if (existingTextHasDecimalSeparator != nil &&
            replacementTextHasDecimalSeparator != nil) || numberAndDecimalInText == nil {
            return false
        } else {
            return true
        }
    }
}
