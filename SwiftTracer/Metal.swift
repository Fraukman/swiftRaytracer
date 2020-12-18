//
//  Metal.swift
//  SwiftTracer
//
//  Created by Juan Souza on 16/12/20.
//  Copyright © 2020 Juan Souza. All rights reserved.
//

import Foundation
import simd
class Metal: Material{
    
   private var albedo: Color3
      
      init(albedo: Color3) {
          self.albedo = albedo
      }
    
    func scatter(r_in: inout Ray, rec: inout hit_record, attenuation: inout Color3, scattered: inout Ray) -> Bool {
        let reflected: Vec3 = reflect(v: &r_in.direction,n: &rec.normal)
        scattered = Ray(origin: rec.p, direction: reflected)
        attenuation = albedo
        return (simd_dot(scattered.direction,rec.normal)>0)
        
    }
}
