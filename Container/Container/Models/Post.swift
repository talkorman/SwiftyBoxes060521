//
//  Post.swift
//  Container
//
//  Created by MacBook on 2021/3/14.
//
//*********************************************************************************
//**            model of a post of a packing list data for communicating with    **
//**            the server                                                       **
//*********************************************************************************
import Foundation
struct Post: Codable{
    var label: String
    var packingList: [PackageData]
    var container: String
    
    init(_ label: String, _ packingList: [PackageData], _ container: String){
        self.label = label
        self.packingList = packingList
        self.container = container
    }
}
