//
//  DataSource.swift
//  Container
//
//  Created by MacBook on 2021/3/6.
//
//*********************************************************************************
//**            Interface with the server                                        **
//*********************************************************************************
import Foundation

class DataSource{
    let httpStatus: [Int : String] = [401 : "You're not logged in",
                                      402: "Password not correct",
                                      201 : "new user successfully created",
                                      202: "New packing list saved successfully",
                                      203: "please check your email to reset your password",
                                      204: "new packing list was updated successfully",
                                      403: "User with this name already exist",
                                      404: "User not exist"
    
    ]
    
    func requestFromServer(apiAddress: String, data: Any?, callback: @escaping (Any?, Any?) -> Void){
        let state = Database.shared.reqState
        let apiAddress = "https://swiftyboxes.herokuapp.com/\(apiAddress)"
        guard let url = URL(string: apiAddress) else {
            DispatchQueue.main.async {
                callback(nil, Message(message: "URL Error"))
            }
            return
        }
        
        var request = URLRequest(url)   //after the Interceptor extension for the token, that's why no (url:url)
        
        request.httpMethod = String(state.rawValue.split(separator: " ")[0])
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            if let data = data{
                if let data = data as? User{
                request.httpBody = try? JSONEncoder().encode(data)
                }else if let data = data as? Post {
                request.httpBody = try? JSONEncoder().encode(data)
                }
            }
      let dataTask =  URLSession.shared.dataTask(with: request) { (data, response, error) in
          
        guard let data = data, let res = response as? HTTPURLResponse, error == nil else{
            DispatchQueue.main.async{
            callback(nil, Message(message: "Server access failure"))
            }
            return
        }
        
        if let code = self.httpStatus[res.statusCode]{
           
            if res.statusCode > 200{
                DispatchQueue.main.async{
                callback(nil, Message(message: code))
                }
            } else if res.statusCode <= 200{
                DispatchQueue.main.async{
                callback(Message(message: code), nil)
            }
            }
                return
            }
        
      
            do{
                let message: Any
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if state == .viewDataOnCloud{
                message = try decoder.decode(MessageList.self, from: data)
                }else if state == .getData{
                    message = try decoder.decode(Post.self, from: data)
                }else if state == .requestLocations{
                    message = try decoder.decode(TotalContainers.self, from: data)
                
                }else {
                message = try decoder.decode(Message.self, from: data)
               
            }
                DispatchQueue.main.async {
                                   callback(message, nil)
                               }

            }catch{
            }
      }
        dataTask.resume()
    }
    
}

enum RequestState: String{
    case startUp =          "GET api/user/"
    case createNewUser =    "POST api/user/signup"
    case postData =         "POST api/posts/post"
    case getData =          "GET api/posts/"
    case updateData =       "PUT api/posts/put"
    case requestLocations = "POST api/algorithm"
    case loggingIn =        "POST api/user/login"
    case viewDataOnCloud =  "GET api/posts/view"
    case deleteData =       "DELETE api/posts/"
    case sendPassword =     "POST api/user/sendPassword"
    
    init(){
        self = .getData
    }
}

enum LoggedIn: String{
    case loggedIn = "Logged in"
    case loggedOut = "Logged out"
    
    init(){
        self = .loggedOut
    }
    
}
struct Message: Decodable{
    var message: String
    var result: Int?
    
    init(message: String){
        self.message = message
    }
}
struct MessageList: Decodable{
    var message: [List]
    var result: Int?
}
struct MessagePackage: Decodable {
    var message: PackageData
    var result: Int?
}
struct TotalContainers: Decodable{
    var h: [Container]
}
//this extension allow to do interception of the token therefore must call URLRequest(value)
extension URLRequest{
    init(_ url:URL){
        self.init(url: url)
        
        guard let token = Database.shared.token else{return}
        self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
