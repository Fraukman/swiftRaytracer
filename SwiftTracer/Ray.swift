//
//  Ray.swift
//  SwiftTracer
//
//  Created by Juan Souza on 13/12/20.
//  Copyright © 2020 Juan Souza. All rights reserved.
//

import Foundation

class Ray{
    var origin: Point3
    var direction: Vec3
    
    init(origin: SIMD3<Float>,direction: SIMD3<Float>){
        self.origin = origin
        self.direction = direction
    }
    
    func at(t: Float)->Point3{
        return origin + (t*direction);
    }
    
}
