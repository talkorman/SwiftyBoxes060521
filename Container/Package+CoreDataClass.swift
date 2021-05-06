//
//  Package+CoreDataClass.swift
//  Container
//
//  Created by MacBook on 2021/2/28.
//
//
//*********************************************************************************
//**           NS Model of a package at the Core data                            **
//*********************************************************************************
import Foundation
import CoreData

@objc(Package) //to let OBJC access to the class
public class Package: NSManagedObject {

    convenience init(name:String, qty q:Int, length l:Int, width w:Int, height h:Int, weight g:Int){
        self.init(context: Database.shared.context)
        
        self.name = name
        self.q = q
        self.l = l
        self.w = w
        self.h = h
        self.g = g
    }
}
extension Package{
    var q: Int {
        get { return Int(qty) }
        set { qty = Int64(newValue) }
     }
    var l: Int {
        get { return Int(length) }
        set { length = Int64(newValue) }
     }
    var w: Int {
        get { return Int(width) }
        set { width = Int64(newValue) }
     }
    var h: Int {
        get { return Int(height) }
        set { height = Int64(newValue) }
     }
    var g: Int {
        get { return Int(weight) }
        set { weight = Int64(newValue) }
     }
}
