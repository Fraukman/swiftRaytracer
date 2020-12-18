//
//  Lambertian.swift
//  SwiftTracer
//
//  Created by Juan Souza on 16/12/20.
//  Copyright © 2020 Juan Souza. All rights reserved.
//

import Foundation

class Lambertian: Material {
    
    private var albedo: Color3
    
    init(albedo: Color3) {
        self.albedo = albedo
    }
    
    func scatter(r_in: inout Ray, rec: inout hit_record, attenuation: inout Color3, scattered: inout Ray) -> Bool {
        let scatter_direction = rec.normal + randomPointInsideUnitSphere()
        
        scattered = Ray(origin: rec.p, direction: scatter_direction)
        attenuation = albedo
        return true
    }
    
    
}
