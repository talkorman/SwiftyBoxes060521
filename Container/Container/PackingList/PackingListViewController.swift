//
//  PackingListViewController.swift
//  Container
//
//  Created by MacBook on 2021/2/27.
//
//*********************************************************************************
//**            Table of packing lists                                           **
//*********************************************************************************
import UIKit
import CoreData

class PackingListViewController: UIViewController {
    let db = Database.shared
    var obs = Set<NSKeyValueObservation>()
    @IBOutlet weak var packingList: UITableView!
    @IBOutlet weak var login: UIBarButtonItem!
    
    //because it's computed, the array is passed by refference
    var packages : [Package] = []
    var indexForEdit: Int = 0
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
      login.title = sender ? "Logged in" : "Looged out"
      login.tintColor = sender ? .systemGreen : .systemRed
   }
override func viewDidLoad() {
    super.viewDidLoad()
    changeLogStatus(db.logState.loggedIn)
    registerObs(db.logState)
    self.packages = Database.shared.getPackingList()
    self.packingList.rowHeight = 150
    self.packingList.reloadData()
    packingList.delegate = self
    packingList.dataSource = self
    
}
   
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if sender is Package{
        if let vc = segue.destination as? EditCellViewController, sender != nil{
            vc.delegate = self
            vc.package = sender as? Package
            vc.indexOfPackage = indexForEdit
        }
        
        return
    }
        let vc:EditCellViewController = segue.destination as! EditCellViewController
        vc.delegate = self
}
func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
}
    
    @IBAction func edit(_ sender: UIButton) {
        let editButtonPosition = sender.convert(CGPoint.zero, to: packingList)
        guard let index = packingList.indexPathForRow(at: editButtonPosition) else {return}
        let cell = packingList.cellForRow(at: index) as? Cell
        let name = cell?.qtyAndName.text?.components(separatedBy: " ")[2]
        let i = packages.firstIndex { (p) -> Bool in
            name == p.name
        }
        self.indexForEdit = i!
        let package: Package = packages[i!]
        performSegue(withIdentifier: "add", sender: package)
    }
}

extension PackingListViewController: UITableViewDelegate, UITableViewDataSource, DeleteCell, AddPackage{
    
    func add(package: Package, indexOfPackage: Int?) {
        if indexOfPackage != nil{
            Database.shared.delete(package: packages[indexOfPackage!])
            packages.remove(at: indexOfPackage!)
            let i = IndexPath(item: indexOfPackage!, section: 0)
            packingList.deleteRows(at: [i], with: .fade)
        }
            packages.append(package)
        packingList.reloadData()
    Database.shared.save(package:package)
}

func didSelect(name: String) {
    
    let index = packages.firstIndex { (p) -> Bool in
        name == p.name
    }
    if index! >= packages.count{return}
    let packageToDelete = packages[index!]
    packages.remove(at: index!)
    let i = IndexPath(item: index!, section: 0)
    packingList.deleteRows(at: [i], with: .fade)
    Database.shared.delete(package: packageToDelete)
}


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return packages.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let pack = packages[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Cell
    cell.delegate = self
    cell.setPackage(package: pack)
    return cell
}

}
