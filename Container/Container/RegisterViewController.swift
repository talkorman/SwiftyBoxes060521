//
//  RegisterViewController.swift
//  Container
//
//  Created by MacBook on 2021/3/3.
//
//*********************************************************************************
//**            New user register UI                                             **
//*********************************************************************************
import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repPassword: UITextField!
    let db = Database.shared
    @IBAction func submit(_ sender: Any) {
        var valid:Bool = true
        var user = User()
       if let validEmail = email?.text, validEmail.isValidEmail == true{
        user.email = validEmail
       }else{
            fixingMessages(field: email, message: "wrong email, please type again!")
            valid = false
        }
        if let validPass = password?.text, repPassword?.text != nil{
            if validPass.isValidPassword == false{
                fixingMessages(field: password, message: "password must contain letters, numbers and symbols")
                valid = false
            }
            if (validPass.caseInsensitiveCompare(repPassword.text!) != .orderedSame){
                fixingMessages(field: password, message: "password not the same. reenter!")
                valid = false
            }
            user.password = validPass
       }else{
            fixingMessages(field: password, message: "please enter password!")
            valid = false
        }
        if valid == true{
            
            //creating new user
            db.reqState = .createNewUser
            let api = String(db.reqState.rawValue.split(separator: " ")[1])
            db.dataSource.requestFromServer(apiAddress: api, data: user){ (message, error) in
                if let error = error as? Message{
                    self.showInputDialog(title: error.message)
                }
                    guard let message = message as? Message else{return}
                self.db.token = nil
                self.db.saveToken()
                self.showInputDialog(title: message.message, actionHandler: self.out(text:))
                self.navigationController?.popViewController(animated: true)
                }
            
    }
        valid = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }

}
extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    var isValidPassword: Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
            return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)

    }
}

extension UIViewController{
    func fixingMessages(field:UITextField, message:String){
        field.text = ""
        field.attributedPlaceholder = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
    }
}


