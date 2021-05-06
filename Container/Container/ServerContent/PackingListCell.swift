//
//  PackingListCell.swift
//  Container
//
//  Created by MacBook on 2021/3/12.
//
//*********************************************************************************
//**            Table cell of each packing list on the server                    **
//*********************************************************************************
import UIKit

class PackingListCell: UITableViewCell {
    var delegate:DeleteCell?
    @IBOutlet weak var packingName: UILabel!
    @IBAction func deleteList(_ sender: UIButton) {
        guard let label = packingName?.text else{return}
        delegate?.didSelect(name: label)
    }
    
    func setList(label: String){
        packingName.text = label
    }

}
