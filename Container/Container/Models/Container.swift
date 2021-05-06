//
//  Container.swift
//  Container
//
//  Created by MacBook on 2021/4/1.
//
//*********************************************************************************
//**            model of a loaded container                                      **
//*********************************************************************************
import Foundation

struct Container: Codable{
    var contDim: ContType
    var packageArray: [LocatedPackage]
    var loadedCbm: Float
    var loadedKg: Float
}
