//
//  LoginViewController.swift
//  RememberMe
//
//  Created by Clovis Magenta da Cunha on 29/01/19.
//  Copyright © 2019 CMC. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {

    let localRealm = try! Realm()
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    @IBOutlet weak var forgetButton: UIButton!
    
    var isRegistrationSegue : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isRegistrationSegue {
            navigationItem.hidesBackButton = true
        }
    }

    @IBAction func forgetButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func performLoginPressed(_ sender: UIBarButtonItem) {
        
        
        performSegue(withIdentifier: "mainTicketsSegue", sender: self)
    }

    func validLogin() -> Bool {
        
        var lValidated = false
        
        return lValidated
    }
    
}
