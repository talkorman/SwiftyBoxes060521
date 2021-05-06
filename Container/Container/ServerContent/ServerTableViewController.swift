//
//  ServerTableViewController.swift
//  Container
//
//  Created by MacBook on 2021/3/12.
//
//*********************************************************************************
//**       This UI for interact with the list of the containers on the server    **
//*********************************************************************************
import UIKit

class ServerTableViewController: UIViewController {
    var db = Database.shared
    var data:[List] = []
    @IBOutlet weak var lists: UITableView!
    @IBAction func open(_ sender: UIButton) {
        let openButtonPosition = sender.convert(CGPoint.zero, to: lists)
        let index = lists.indexPathForRow(at: openButtonPosition)
        guard let ind = index else {return}
        let cell = lists.cellForRow(at: ind) as? PackingListCell
        guard let name = cell?.packingName?.text else {return}
        let i = data.firstIndex { (list) -> Bool in
            list.label == name
        }
        guard let indx = i else {return}
        let id = data[indx].id
        db.loadList(id) { (package) in
            self.db.packingListName = name
            self.db.savePackName()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lists.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        db.reqState = .viewDataOnCloud
        db.viewAllLists { (list) in
            
            if let message = list as? Message{
                self.showInputDialog(title: message.message, actionHandler: self.out(text:))
            }
            guard let list = list as? [List] else {return}
            self.data = list
            
        }
        lists.reloadData()
        lists.delegate = self
        lists.dataSource = self
}
}
extension ServerTableViewController: UITableViewDelegate, UITableViewDataSource, DeleteCell{

    func didSelect(name label: String) {
        let ind = data.firstIndex { (p) -> Bool in
            label == p.label
    }
    guard let index = ind else{return}
    db.reqState = .deleteData
        db.deleteOnCloud(data[index].id){
            () in
        
            self.data.remove(at: index)
            let i = IndexPath(item: index, section: 0)
            self.lists.deleteRows(at: [i], with: .fade)
        }
    
        
    //packingList.reloadData()
}


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let label = data[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "listscell") as! PackingListCell
    cell.delegate = self
    cell.setList(label: label.label)
    return cell
}

}

