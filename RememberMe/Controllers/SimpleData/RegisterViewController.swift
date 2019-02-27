//
//  RegisterViewController.swift
//  RememberMe
//
//  Created by Clovis Magenta da Cunha on 29/01/19.
//  Copyright © 2019 CMC. All rights reserved.
//

import UIKit
import RealmSwift

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var familyName: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var passwordDiffLabel: UILabel!
    @IBOutlet var passworkStrongProgress: UIView!
    @IBOutlet weak var strongPasswordLabel: UILabel!
    
    let realmConnection = try! Realm()
    var lastField : Int = 0
    var newUser : Users!
    var nLevel = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user.delegate = self
        firstName.delegate = self
        familyName.delegate = self
        country.delegate = self
        city.delegate = self
        email.delegate = self
        password.delegate = self
        password2.delegate = self

        updateProgress(actualLevel : nLevel)
        
    }

    @IBAction func addUserTipped(_ sender: Any) {

        let continueProcess : Bool = validValues()
        newUser = Users()
        
        if continueProcess {
            
            newUser.userName = user.text!
            newUser.firstName = firstName.text!
            newUser.familyName = familyName.text!
            newUser.country = country.text!
            newUser.city = city.text!
            newUser.email = email.text!
            newUser.password = password.text!
            newUser.validationCode = Int.random(in: 1000...9999)

            commitUserData( thisUser: newUser )
            
            performSegue(withIdentifier: "registerConfirmationSegue", sender: self)
        }
    }
    
    func commitUserData( thisUser : Users ) {
        
        do {
            try realmConnection.write {
                realmConnection.add( thisUser )
            }
        } catch {
            print("Error commiting new User: \(error)")
        }
    }
    
    func validValues() -> Bool{
        
        var lOk : Bool = true
        let redColor = UIColor.red.cgColor
        
        if user.text!.isEmpty {
            user.layer.borderColor = redColor
            lOk = false
        }
        if firstName.text!.isEmpty {
            firstName.layer.borderColor = redColor
            lOk = false
        }
        if familyName.text!.isEmpty {
            familyName.layer.borderColor = redColor
            lOk = false
        }
        if country.text!.isEmpty {
            country.layer.borderColor = redColor
            lOk = false
        }
        if city.text!.isEmpty {
            city.layer.borderColor = redColor
            
            lOk = false
        }
        if email.text!.isEmpty {
            email.layer.borderColor = redColor
            lOk = false
        }
        if password.text!.isEmpty {
            password.layer.borderColor = redColor
            lOk = false
        }
        if password2.text!.isEmpty {
            password2.layer.borderColor = redColor
            lOk = false
        }
        
        if password.text! != password2.text {
            password2.layer.borderColor = redColor
            passwordDiffLabel.text = "Passwords do not match!"
            passwordDiffLabel.isHidden = false
            lOk = false
        }
        
        return lOk
    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField.tag == 6 || textField.tag == 7 {
            passwordDiffLabel.isHidden = true

            nLevel = checkPassword(thisPassword: textField.text! )

            updateProgress(actualLevel : nLevel)
        }
        
        lastField = textField.tag
        
        
        return true
    }
    
    func updateProgress( actualLevel : Int) {
        passworkStrongProgress.frame.size.width =  28.25  * CGFloat(nLevel)
        
        if nLevel <= 2 {
            passworkStrongProgress.backgroundColor = UIColor.red
            strongPasswordLabel.text = "Weak."
        } else if nLevel <= 4 {
            passworkStrongProgress.backgroundColor = UIColor.yellow
            strongPasswordLabel.text = "Can be better..."
        } else if nLevel <= 6 {
            passworkStrongProgress.backgroundColor = UIColor.blue
            strongPasswordLabel.text = "Good!"
        } else if nLevel >= 8 {
            passworkStrongProgress.backgroundColor = UIColor.green
            strongPasswordLabel.text = "Excelent!!!"
        }
    }
    
    func checkPassword( thisPassword : String ) -> Int {
        
        let lowerCase = CharacterSet.lowercaseLetters
        let upperCase = CharacterSet.uppercaseLetters
        let specialCase = CharacterSet.symbols
        var nLevel = 0
        var lUpper = false
        var lLower = false
        var lSpecial = false
        
        // Has lower and Upper Case?
        for currentCharacter in thisPassword.unicodeScalars {
            if lowerCase.contains(currentCharacter) && !lLower{
                nLevel += 2
                lLower = true
            }
            if upperCase.contains(currentCharacter) && !lUpper {
                nLevel += 2
                lUpper = true
            }
            if specialCase.contains(currentCharacter) && !lSpecial {
                nLevel += 2
                lSpecial = true
            }
        }
        
        if thisPassword.count >= 8 {
            nLevel += 2
        }
        
        return nLevel
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextView = segue.destination as! RegisterConfirmationViewController
        nextView.selectedUser = newUser
        
    }
    

}
