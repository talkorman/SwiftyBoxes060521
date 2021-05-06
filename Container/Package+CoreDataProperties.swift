//
//  Package+CoreDataProperties.swift
//  Container
//
//  Created by MacBook on 2021/2/28.
//
//
//*********************************************************************************
//**            Extension for the Core data model                                **
//*********************************************************************************
import Foundation
import CoreData


extension Package {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Package> {
        return NSFetchRequest<Package>(entityName: "Package")
    }

    @NSManaged public var name: String
    @NSManaged public var qty: Int64
    @NSManaged public var length: Int64
    @NSManaged public var width: Int64
    @NSManaged public var height: Int64
    @NSManaged public var weight: Int64

}

extension Package : Identifiable {

}
