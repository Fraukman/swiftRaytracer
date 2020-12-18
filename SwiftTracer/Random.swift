//
//  Random.swift
//  SwiftTracer
//
//  Created by Juan Souza on 15/12/20.
//  Copyright © 2020 Juan Souza. All rights reserved.
//

import Foundation
import simd

func random01() -> Float {
    return Float(arc4random())/Float(UInt32.max)
}

func randomMinus1Plus1() -> Float {
    return 2.0 * random01() - 1.0
}

func randomPointInsideUnitSphere() -> Vec3 {
    let radius = random01()
    return radius * simd_normalize(Vec3(randomMinus1Plus1(), randomMinus1Plus1(), randomMinus1Plus1()))
}

func randomInUnitdisk() -> Vec3{
    while true {
        let p = Vec3(Float.random(in: -1...1),Float.random(in: -1...1),0)
        if(simd_length_squared(p)>=1){continue}
        return p
    }
}
