//
//  PackageLocation.swift
//  Container
//
//  Created by MacBook on 2021/3/30.
//
//*********************************************************************************
//**            model of a package location inside the container                 **
//*********************************************************************************
import Foundation
struct PackageLocation: Codable {
    var x: Float
    var y: Float
    var z: Float
    var xc: Float
    var yc: Float
    var zc: Float
    init(_ x: Float, _ y: Float, _ z: Float, _ xc: Float, _ yc: Float, _ zc: Float){
        self.x = x
        self.y = y
        self.z = z
        self.xc = xc
        self.yc = yc
        self.zc = zc
    }
}
