//
//  Dielectric.swift
//  SwiftTracer
//
//  Created by Juan Souza on 16/12/20.
//  Copyright © 2020 Juan Souza. All rights reserved.
//

import Foundation
import simd

class Dielectric: Material{
    
    private let ir:Float
    
    init(ir: Float) {
        self.ir = ir
    }
    
    private func reflectance(cosine: Float, ref_idx: Float) -> Float{
        var r0 = (1-ref_idx) / (1+ref_idx)
        r0 = r0*r0
        return r0 + (1-r0) * pow((1-cosine),5)
    }
    
    func scatter(r_in: inout Ray, rec: inout hit_record, attenuation: inout Color3, scattered: inout Ray) -> Bool {
        attenuation = Color3(1,1,1)
        let refraction_ratio = rec.front_face ? (1.0/ir) : ir
        
        var unit_direction: Vec3 = simd_normalize(r_in.direction)
        let cos_theta = min(simd_dot(-unit_direction,rec.normal),1.0)
        let sin_theta = sqrt(1.0 - (cos_theta * cos_theta))
        
        let cannot_reflect: Bool = refraction_ratio * sin_theta > 1.0
        var direction: Vec3
        
        if(cannot_reflect || (reflectance(cosine: cos_theta, ref_idx: refraction_ratio) > random01())){
            direction = reflect(v: &unit_direction,n: &rec.normal)
        }else{
            direction = refract(uv: &unit_direction, n: &rec.normal, etai_over_etat: refraction_ratio)
        }
        
        scattered = Ray(origin: rec.p, direction: direction)
        
        return true
    }
    
    
}
