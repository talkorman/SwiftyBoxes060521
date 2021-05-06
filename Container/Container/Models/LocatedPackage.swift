//
//  LocatedPackage.swift
//  Container
//
//  Created by MacBook on 2021/4/2.
//
//*********************************************************************************
//**    model of a package that already has a location destination inside the    **
//**    container                                                                **
//*********************************************************************************
import Foundation
struct LocatedPackage: Codable{
    var item: Int
    var name: String
    var qty: Int
    var length: Float
    var width: Float
    var height: Float
    var weight: Float
    var cbm: Float
    var locate: Bool
    var location: PackageLocation
    init(_ item: Int, _ name: String, _ qty: Int, _ length: Float, _ width:Float, _ height:Float, _ weight: Float, _ cbm: Float, _ locate: Bool, _ location: PackageLocation ){
        self.item = item
        self.name = name
        self.qty = qty
        self.length = length
        self.width = width
        self.height = height
        self.weight = weight
        self.cbm = cbm
        self.locate = locate
        self.location = location
    }
}
