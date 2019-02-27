//
//  ViewController.swift
//  RememberMe
//
//  Created by Clovis Magenta da Cunha on 29/01/19.
//  Copyright © 2019 CMC. All rights reserved.
//

import UIKit
import RealmSwift

class WelcomeViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func loginPressed(_ sender: UIButton) {
    
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "registerSegue", sender: self)
    }
}

