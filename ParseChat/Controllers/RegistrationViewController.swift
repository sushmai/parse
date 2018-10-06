//
//  RegistrationViewController.swift
//  ParseChat
//
//  Created by Sanaz Khosravi on 9/19/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class RegistrationViewController: UIViewController {
    @IBOutlet var submitButtonOutlet: UIButton!
    @IBOutlet var password: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var userNameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButtonOutlet.isEnabled = false
        [userNameLabel, password, emailText].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if userNameLabel.text?.characters.count == 1 {
            if userNameLabel.text?.characters.first == " " {
                userNameLabel.text = ""
                return
            }
        }
        guard
            let userN = userNameLabel.text, !(userNameLabel.text?.isEmpty)!,
            let pass = password.text, !(password.text?.isEmpty)!,
            let email = emailText.text, !(emailText.text?.isEmpty)!
            else {
                submitButtonOutlet.isEnabled = false
                return
        }
        submitButtonOutlet.isEnabled = true
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let userName = userNameLabel.text
        let pass = password.text
        let email = emailText.text ?? ""
        MBProgressHUD.showAdded(to: self.view, animated: true)
        registerUser(userName!, pass!, email)

    }
    
    


    func registerUser(_ username : String, _ password : String, _ email : String) {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.email = email
        newUser.username = username
        newUser.password = password
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.createAlert("Login Failed!", error.localizedDescription)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.createAlert("Success!", "User Registered successfully")
            }
        }
    }
    
    func createAlert(_ title : String, _ message : String){
        let titleText = title
        let messageText = message
        let alert = UIAlertController(title: titleText, message:
            messageText, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }

}
