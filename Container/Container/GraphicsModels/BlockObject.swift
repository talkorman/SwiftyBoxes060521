//
//  BlockObject.swift
//  Container
//
//  Created by MacBook on 2021/3/30.
//
//*********************************************************************************
//**           This model is for general block 3D object used for the            **
//**            container's walls and for the boxes                              **
//*********************************************************************************
import Foundation
import UIKit
struct BlockObject {
    let l: CGFloat
    let w: CGFloat
    let h: CGFloat
    let x: CGFloat
    let y: CGFloat
    let z: CGFloat
    let color: UIColor
    let material: UIImage?
}
