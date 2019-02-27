//
//  RegisterConfirmationViewController.swift
//  RememberMe
//
//  Created by Clovis Magenta da Cunha on 06/02/19.
//  Copyright © 2019 CMC. All rights reserved.
//

import UIKit

class RegisterConfirmationViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var codeInformationText: UITextField!
    
    @IBOutlet weak var helloText: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    
    var selectedUser : Users!
    
    override func viewDidLoad() {
        
        if let nameDisplayed = selectedUser?.userName {
            helloText.text = "Hello \(nameDisplayed)!"
        }
        
        codeInformationText.delegate = self
        
    }
    
    @IBAction func validCode(_ sender: Any) {
    
        if let codeTyped = codeInformationText.text {
            
            if Int(codeTyped) != selectedUser?.validationCode {
                alertLabel.isHidden = false
            } else {
                performSegue(withIdentifier: "validUserSegue", sender: self)
            }
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView = segue.destination as! LoginViewController
        nextView.isRegistrationSegue = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        alertLabel.isHidden = true
        
        return true
    }
}
