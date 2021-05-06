//
//  User.swift
//  Container
//
//  Created by MacBook on 2021/3/3.
//
//*********************************************************************************
//**            This model of the user on the backend                            **
//*********************************************************************************
import Foundation
struct User: Codable{
    var email:String
    var password:String
    init(_ email:String = "", _ password: String = ""){
        self.email = email
        self.password = password
    }
}
