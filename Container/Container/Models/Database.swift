//
//  Database.swift
//  Container
//
//  Created by MacBook on 2021/2/28.
//
//*********************************************************************************
//**           Singleton class for data flow between the UI, core data and       **
//**           the server data and for storing some global variables and objects **
//*********************************************************************************
import Foundation
import CoreData

class Database{
    
let dataSource = DataSource()
var reqState = RequestState()
var logState = LogIn()
var token:String?
    var userName: String?
    //for limiting the user name not to overlap the title
    var userShort: String{
        guard let user = userName else{ return ""}
        let n = user.count > 8 ? String(user.dropLast(user.count - 8)): user
        return String(n)
    }
    var packingListName: String?
    var test: Bool = false
lazy var persistentContainer: NSPersistentContainer = {
    
       let container = NSPersistentContainer(name: "Container")
       container.loadPersistentStores(completionHandler: { (storeDescription, error) in
           if let error = error as NSError? {
            
               fatalError("Unresolved error \(error), \(error.userInfo)")
           }
       })
       return container
   }()
    
    var context: NSManagedObjectContext{
            return persistentContainer.viewContext
        }
    var timer: Timer?
    
    private init(){
       timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(testConnection), userInfo: nil, repeats: true)
    }
   // var logStatus = LoggedIn()
    static let shared = Database()
    
    lazy var packages:[Package] = getPackingList()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
             
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func delete(package:Package){
        context.delete(package)
        saveContext()
    }
    
    func save(package: Package){
        saveContext()
    }
    
    @objc func testConnection(){
        reqState = .viewDataOnCloud
        viewAllLists { (list) in
            guard list is Message else{
                self.logState.loggedIn = true
                return
            }
            self.logState.loggedIn = false
        }
        }
    
    //this function do both: save or updat user's packing lists in DB and also sends packing lists
    //for the algorithm for calculating their locations, according to reqState status
    func uploadToCloud(_ label:String, _ callback: @escaping(_ list: Any)->Void?){
        let packages = getPackingList()
        var packingList: [PackageData] = []
        for p in packages{
            packingList.append(PackageData(p.name, p.q, p.l, p.w, p.h, p.g))
        }
        let contype = ContainerType.size20fit
        let post = Post(label, packingList, contype.contArr.size)
        let api = String(reqState.rawValue.split(separator: " ")[1])
        dataSource.requestFromServer(apiAddress: api, data: post) { (message, error) in
            if let error = error as? Message{
            callback(error)
                return
                }
            guard let message = message else{
                self.logState.loggedIn = false
                var m = Message(message: "server failure")
                m.result = 404
                callback(m)
                return
            }
            guard let list = message as? TotalContainers else{ return}
            //here need a delegate for the SceneControlView
            callback(list as TotalContainers)
        }
    }
    //for viewing list all the packing lists on the server
    func viewAllLists(_ callback: @escaping (_ data: Any)-> Void){
        var list:[List] = []
        let api = String(reqState.rawValue.split(separator: " ")[1])
        dataSource.requestFromServer(apiAddress: api, data: nil) { (message, error) in
            guard let message = message as? MessageList else{
                callback(error as? Message ?? [])
                self.logState.loggedIn = false
                return
            }
            list = message.message as [List]
            callback(_ : list)
        }
    }
    //for downloading a specific Packinglist from the cloud to the Database uppon it's id
    func loadList(_ id: String, _ callback: @escaping (_ data: Package)-> Void){
        reqState = .getData
        let api = String(reqState.rawValue.split(separator: " ")[1]) + id
        dataSource.requestFromServer(apiAddress: api, data: nil) { (message, error) in
            guard let message = message as? Post else {
                self.logState.loggedIn = false
                return
            }
            let packingList = message.packingList
            self.deleteAllDataBase()
            self.saveContext()
            for p in packingList{
                guard let n = p.name else{ return}
                guard let q = p.qty else{ return}
                guard let l = p.length else{ return}
                guard let w = p.width else{ return}
                guard let h = p.height else{ return}
                guard let g = p.weight else{ return}
                let pack = Package(name: n, qty: q, length: l, width: w, height: h, weight: g)                
            self.save(package: pack)
                callback(pack)
            }
        }
    }
    func deleteOnCloud(_ postId: String, _ callback: @escaping ()-> Void){
        let api = String(reqState.rawValue.split(separator: " ")[1]) + postId
        dataSource.requestFromServer(apiAddress: api, data: nil) { (message, error) in
            _ = message as? String
        callback()
        }
        
        
    }
    func getPackingList() -> [Package]{
    let request:NSFetchRequest<Package> = Package.fetchRequest()
        if let packingList = try? context.fetch(request){
            return packingList
        }
        var packingList:[Package] = []
        packingList.append(Package(name:"Login please", qty:10, length: 12, width: 20, height: 28, weight: 8))
        return []
}
    func deleteAllDataBase(){
        let packages = getPackingList()
        for package in packages{
            delete(package: package)
        }
    }
    func saveToken(){
        let token = UserDefaults.standard
        token.set(self.token, forKey: "token")
        token.synchronize()
    }
    func savePackName(){
        let packName = UserDefaults.standard
        packName.set(self.packingListName, forKey: "packingListName")
        packName.synchronize()
    }
    func saveUserName(){
        if self.userName == self.userName{
        let userName = UserDefaults.standard
        userName.set(self.userName, forKey: "userName")
        userName.synchronize()
        }
    }
    func loadToken(){
        let token = UserDefaults.standard
        guard let accessTokenValue = token.string(forKey: "token") else {return}
        self.token = accessTokenValue
        logState.loggedIn = true
    }
    func loadPackName(){
        let packName = UserDefaults.standard
        guard let accessNameValue = packName.string(forKey: "packingListName") else {return}
        self.packingListName = accessNameValue
    }
    func loadUserName(){
        let userName = UserDefaults.standard
        guard let accessNameValue = userName.string(forKey: "userName") else {return}
        self.userName = accessNameValue
    }
}

class LogIn: NSObject{
    @objc dynamic var loggedIn: Bool = false
}

class LogInObserver{
    var obs = Set<NSKeyValueObservation>()
}
