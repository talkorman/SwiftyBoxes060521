//
//  Cell.swift
//  Container
//
//  Created by MacBook on 2021/2/27.
//
//*********************************************************************************
//**            Table cell of a package item inside the packing list             **
//*********************************************************************************
import UIKit

class Cell: UITableViewCell {
    var delegate:DeleteCell?
    @IBOutlet weak var qtyAndName: UILabel!
    @IBOutlet weak var dimensions: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBAction func deleteCell(_ sender: UIButton) {
        
        let arr = qtyAndName.text?.components(separatedBy: " ")
        if let name = arr?[2]{
        delegate?.didSelect(name: name)
        }
    }
    func setPackage(package: Package){
        let name = "\(package.qty) x \(package.name)"
        let dim = "\(package.length)cm x \(package.width)cm x \(package.height)cm"
        let w = "\(package.weight)Kg"
        qtyAndName.text = name
        dimensions.text = dim
        weight.text = w
    }
}
protocol DeleteCell {
    func didSelect(name:String)
}
