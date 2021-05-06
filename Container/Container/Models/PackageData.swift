//
//  PackageData.swift
//  Container
//
//  Created by MacBook on 2021/3/5.
//
//*********************************************************************************
//**            Swift Model of a package                                         **
//*********************************************************************************
import Foundation
struct PackageData: Codable{
    var name: String?
    var qty: Int?
    var length: Int?
    var width: Int?
    var height: Int?
    var weight: Int?
    init(_ name: String, _ q: Int, _ l: Int, _ w: Int, _ h: Int, _ g: Int){
        self.name = name
        self.qty = q
        self.length = l
        self.width = w
        self.height = h
        self.weight = g
        
}
}

