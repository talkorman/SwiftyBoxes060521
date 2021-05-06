//
//  ContType.swift
//  Container
//
//  Created by MacBook on 2021/3/30.
//
//*********************************************************************************
//**            Model of a container type                                        **
//*********************************************************************************
import Foundation
struct ContType: Codable {
    var l: Float
    var w: Float
    var h: Float
    var maxLoad: Float
    var size: String
}
