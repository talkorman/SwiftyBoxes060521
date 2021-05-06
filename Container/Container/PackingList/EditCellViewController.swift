//
//  EditCellViewController.swift
//  Container
//
//  Created by MacBook on 2021/2/27.
//
//*********************************************************************************
//**            Editing packing list UI                                          **
//*********************************************************************************
import UIKit

class EditCellViewController: UIViewController {
        weak var delegate: AddPackage?
    var package: Package?
    var indexOfPackage: Int? = nil
    var editOrAdd: Bool = false
        var correct:[Bool] = [false, false, false, false, false, false]
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var qty: UITextField!
    @IBOutlet weak var length: UITextField!
    @IBOutlet weak var width: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    
    @IBAction func confirm(_ sender: UIButton) {
       
    var n:String = "", q:Int = 0, l:Int = 0, w:Int = 0, h:Int = 0, g:Int = 0
    if let pName = name?.text, pName.count > 1, pName.isAlphabetical{
        n = pName
        correct[0] = true
    }else{
        fixingMessages(field: name, message: "correct the description")
    }
    if let _pQty = qty?.text{
        if let pQty = Int(_pQty), pQty > 0{
            correct[1] = true
            q = pQty
        }else{
            fixingMessages(field: qty, message: "ilegal quantity")
        }
            
            }
    if let _pLength = length?.text{
        if let pLength = Int(_pLength), pLength > 0, pLength <= 1200{
            correct[2] = true
            l = pLength
        }else{
            fixingMessages(field: length, message: "length 1 - 1200cm")
        }
    }
    if let _pWidth = width?.text{
        if let pWidth = Int(_pWidth), pWidth > 0, pWidth <= 235{
            correct[3] = true
            w = pWidth
        }else{
            fixingMessages(field: width, message: "width 1 - 235cm")
        }
    }
    if let _pHeight = height?.text{
        if let pHeight = Int(_pHeight), pHeight > 0, pHeight <= 265{
            correct[4] = true
            h = pHeight
        }else{
            fixingMessages(field: height, message: "height 1 - 265cm")
        }
    }
    if let _pWeight = weight?.text{
        if let pWeight = Int(_pWeight), pWeight > 0, pWeight < 4500{
            correct[5] = true
            g = pWeight
        }else{
            fixingMessages(field: weight, message: "weight Kg")
        }
    }
    for c in correct{
        if c == false{
            return
        }
    }//*********************************************************************************
        //**            This VC class is rendering the graphics                          **
        //*********************************************************************************
        let package = Package(name:n, qty: q, length:l, width:w, height:h, weight:g)
            self.delegate?.add(package: package, indexOfPackage: indexOfPackage)
    dismiss(animated: true, completion: nil)
}

override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    //If editing the package
    if package != nil{
        self.name.text = package?.name
        self.qty.text = String(package?.q ?? 0)
        self.length.text = String(package?.l ?? 0)
        self.width.text = String(package?.w ?? 0)
        self.height.text = String(package?.h ?? 0)
        self.weight.text = String(package?.w ?? 0)
    }
}
}

extension String{
var isAlphabetical:Bool{
    return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
}
}
protocol AddPackage: class {    //in order to make the weak var
    func add(package:Package, indexOfPackage: Int?)
}

