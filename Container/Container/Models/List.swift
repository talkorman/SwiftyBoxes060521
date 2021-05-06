//
//  List.swift
//  Container
//
//  Created by MacBook on 2021/3/21.
//
//*********************************************************************************
//**            Model for list of packages on the server                         **
//*********************************************************************************
import Foundation
struct List:Decodable {
    let label:String
    let id: String
}
