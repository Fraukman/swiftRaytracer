//
//  Material.swift
//  SwiftTracer
//
//  Created by Juan Souza on 16/12/20.
//  Copyright © 2020 Juan Souza. All rights reserved.
//

import Foundation

protocol Material {
    func scatter(r_in: inout Ray,rec: inout hit_record,attenuation: inout Color3,scattered: inout Ray) -> Bool
}

