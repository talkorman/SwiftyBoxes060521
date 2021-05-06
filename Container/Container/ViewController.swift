//
//  ViewController.swift
//  Container
//
//  Created by MacBook on 2021/2/27.
//
//*********************************************************************************
//**            Main UI screen                                                   **
//*********************************************************************************
import UIKit

class ViewController: UIViewController {
    var nameSave: String?
    let db = Database.shared
    var obs = Set<NSKeyValueObservation>()
    func actionResult(_ list: Any){
        guard let list = list as? Message else{
            return
        }
        showInputDialog(title: list.message, actionHandler: out(text:))
    }
    @IBOutlet weak var logStatus: UIBarButtonItem!
    @IBOutlet weak var login: UIBarButtonItem!
    
    @IBOutlet weak var packName: UILabel!
    
    @IBAction func update(_ sender: Any) {
        guard let name = db.packingListName else {return}
        db.reqState = .updateData
        db.uploadToCloud(name, self.actionResult(_:))
    }
    @IBAction func save(_ sender: UIButton) {
        showInputDialog(title: "Save List", subtitle: "Save list to server", action: "save", cancel: "cancel", textField: true, placeHolder: "packing list name", cancelHandler: nil) { (name) in
            guard let name = name else {return}
            if name == ""{ self.save(sender)}
            self.db.reqState = .postData
            self.db.uploadToCloud(name, self.actionResult(_:))
        }
    }
   
   
    func registerObs(_ log: LogIn){
        let opt: NSKeyValueObservingOptions = [.old, .new]
        let ob = log.observe(\.loggedIn, options: opt) { (obj, change) in
            if let newValue = change.newValue{
                self.changeLogStatus(newValue)
            }
        }
        obs.insert(ob)
    }

    func changeLogStatus(_ sender: Bool){
      login.title = sender ? "Log out" : "Log in"
        logStatus.title = sender ? "Logged in \(db.userShort )" : "Looged out"
        
        logStatus.tintColor = sender ? .green : .red
   }
    override func viewDidAppear(_ animated: Bool) {
        guard let name = db.packingListName else{
            packName.text = "Welcome"
            return
        }
        packName.text = "Packing list name: \(name)"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLogStatus(db.logState.loggedIn)
        registerObs(db.logState)
       
        }
    }

extension UIViewController {
    var apiAddress: String{
        return String(Database.shared.reqState.rawValue.split(separator: " ")[1])
    }
    var orientationLock: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         action:String? = "OK",
                         cancel:String? = "Cancel",
                         textField:Bool = false,
                         placeHolder:String? = nil,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        if textField{
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = placeHolder
            textField.keyboardType = .default
        }
        }
        alert.addAction(UIAlertAction(title: action, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    //return to main screen
    func out(text: String?){
           self.navigationController?.popViewController(animated: true)
       }
}

extension ViewController{
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       AppUtility.lockOrientation(.portrait)
       // Or to rotate and lock
       // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.compactAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
       
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       
       // Don't forget to reset when view is being removed
    AppUtility.lockOrientation(.all)
   }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
}

extension UINavigationController{
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return topViewController?.supportedInterfaceOrientations ?? .allButUpsideDown
    }
}
struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}


