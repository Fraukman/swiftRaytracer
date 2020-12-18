//
//  Sphere.swift
//  SwiftTracer
//
//  Created by Juan Souza on 13/12/20.
//  Copyright © 2020 Juan Souza. All rights reserved.
//

import Foundation
import simd

class Sphere: Hittable{
    
    private let center: Point3
    private let radius: Float
    private let mat_ptr: Material
    
    init(center: Point3, radius: Float,mat_ptr: Material) {
        self.center = center
        self.radius = radius
        self.mat_ptr = mat_ptr
    }

    
    override func hit(r: inout Ray, t_min: Float, t_max: Float, rec: inout hit_record) -> Bool {
        let oc: Vec3 = r.origin - center
        let a = simd_length_squared(r.direction)
        let half_b = simd_dot(oc,r.direction)
        let c = simd_length_squared(oc) - (radius * radius)
        
        let discriminant = half_b * half_b - a * c
        if(discriminant < 0) {return false}
        let sqrtd = sqrt(discriminant)
        
        var root = (-half_b - sqrtd) / a
        if(root < t_min || t_max < root){
            root = (-half_b + sqrtd) / a
            if(root < t_min || t_max < root){
                return false
            }
        }
        
        rec.t = root
        rec.p = r.at(t: rec.t)
        var outwardNormal: Vec3 = (rec.p - center) / radius
        rec.set_face_normal(r: &r, outwardNormal: &outwardNormal)
        rec.mat_ptr = mat_ptr
        
        return true
    }
    
}
