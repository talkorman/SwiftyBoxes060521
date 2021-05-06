//
//  LoginViewController.swift
//  Container
//
//  Created by MacBook on 2021/3/10.
//
//*********************************************************************************
//**            User loging UI                                                   **
//*********************************************************************************
import UIKit

class LoginViewController: UIViewController {
    let db = Database.shared
    private var token: String?
    @IBOutlet weak var loginStatus: UIBarButtonItem!
    
    
    @IBAction func passwordSend(_ sender: UIButton) {
        sendPassword()
    }
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func login(_ sender: UIButton) {
        guard let validEmail = email.text, validEmail.isValidEmail else{
            fixingMessages(field: email, message: "ilegal email, please re enter")
            return
        }
        guard let validPass = password.text, validPass.isValidPassword == true, validPass.count >= 6 else{
            fixingMessages(field: password, message: "password with 6 digits, A, a, 1, $")
            return
        }
        let user = User(_:validEmail, _:validPass)
        db.reqState = .loggingIn
        db.dataSource.requestFromServer(apiAddress: apiAddress, data: user) { (message, error) in
            if let error = error as? Message{
                self.showInputDialog(title: error.message, cancel: "forgot password", cancelHandler:  { (h) in
                    self.sendPassword()
                })
            }
                    guard let message = message as? Message else{
                        self.showInputDialog(title: "Connection Error")
                        return
                    }
            Database.shared.token = (message ).message
                    sender.isEnabled = false
                    self.db.logState.loggedIn = true
                    self.db.userName = "as \(String(validEmail.split(separator: "@")[0]))"
                    self.db.saveUserName()
                    self.navigationController?.popViewController(animated: true)
                    Database.shared.saveToken()
                }
            }
    func sendPassword(){
        showInputDialog(title: "Please enter your email address", subtitle: "and we will send you a link to reset your password", action: "Confirm", cancel: "Cancel", textField: true, placeHolder: "josef@abc.com", actionHandler:  { (email) in
            guard let validEmail = email, validEmail.isValidEmail else{
                self.showInputDialog(title: "not a legal email address, please reenter", actionHandler:  { (h) in
                    self.sendPassword()
                })
                return
            }
            let user = User(validEmail, "12345")
            self.db.reqState = .sendPassword
            self.db.dataSource.requestFromServer(apiAddress: self.apiAddress, data: user) { (message, error) in
                guard let error = error as? Message else{
                    return
                }
                self.showInputDialog(title: error.message)
            }
        })
    }
    func changeLogStatus(_ sender: Bool){
      loginStatus.title = sender ? "Logged in" : "Looged out"
      loginStatus.tintColor = sender ? .systemGreen : .systemRed
   }
            override func viewDidLoad() {
                super.viewDidLoad()
                // Do any additional setup after loading the view.
                changeLogStatus(db.logState.loggedIn)
                if db.logState.loggedIn{
                    db.logState.loggedIn = false
                    db.token = nil
                    db.saveToken()
                    self.navigationController?.popViewController(animated: true)
                }
                (self.view.subviews[2] as! UIButton).isEnabled = db.logState.loggedIn ? false : true
            }
        }
