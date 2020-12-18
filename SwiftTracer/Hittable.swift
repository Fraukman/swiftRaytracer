//
//  Hittable.swift
//  SwiftTracer
//
//  Created by Juan Souza on 13/12/20.
//  Copyright © 2020 Juan Souza. All rights reserved.
//

import Foundation
import simd

struct hit_record{
    var p: Point3
    var normal: Vec3
    var t: Float
    var front_face: Bool
    var mat_ptr: Material?
    
    mutating func set_face_normal(r: inout Ray, outwardNormal: inout Vec3){
        front_face = simd_dot(r.direction,outwardNormal) < 0
        normal = front_face ? outwardNormal : -outwardNormal
    }
}

class Hittable{
    
    func hit(r: inout Ray,t_min: Float,t_max:Float,rec: inout hit_record) -> Bool{
        return false
    }
}
