//
//  Helpers.swift
//  SwiftTracer
//
//  Created by Juan Souza on 13/12/20.
//  Copyright © 2020 Juan Souza. All rights reserved.
//

import Foundation
import simd


typealias Point3 = SIMD3<Float>
typealias Vec3 = SIMD3<Float>
typealias Color3 = SIMD3<Float>

func hitSphere(center: Point3, radius: Float, r: inout Ray )->Float{
    let oc: Vec3 = r.origin - center
    let a = simd_length_squared(r.direction)
    let half_b = simd_dot(oc,r.direction)
    let c = simd_length_squared(oc) - radius * radius
    let discriminant = half_b * half_b - a * c
    if (discriminant < 0){
        return -1
    }else{
        return (-half_b - sqrt(discriminant))/a
    }
    
}

func rayColor(r: inout Ray, world: inout HittableList, depth: Int) -> Color3{
    var rec: hit_record = hit_record(p: Point3(0,0,0), normal: Vec3(0,0,0), t: 0, front_face: false, mat_ptr: nil)
    if (depth <= 0){return Color3(0,0,0)}
    if(world.hit(r: &r,t_min: 0.001,t_max: Float.infinity,rec: &rec)){
        var scattered: Ray = Ray(origin: Point3(0,0,0), direction: Point3(0,0,0))
        var attenuation: Color3 = Color3(0,0,0)
        if(rec.mat_ptr!.scatter(r_in: &r, rec: &rec, attenuation: &attenuation, scattered: &scattered)){
            return attenuation * rayColor(r: &scattered, world: &world, depth: depth - 1)
        }
        return Color3(0,0,0)
    }
    let unitDirection: Vec3 = simd_normalize(r.direction)
    let t = 0.5 * (unitDirection.y + 1.0)
    return (1.0-t)*Color3(1,1,1) + t * Color3(0.5,0.7,1.0)
}

func writeColor(stringOut: inout String, pixelColor: SIMD3<Float>, samplesPerPixel: Int){
    var r = pixelColor.x
    var g = pixelColor.y
    var b = pixelColor.z
    
    let scale: Float = Float(1.0) / Float(samplesPerPixel)
    r = sqrt(scale * r)
    g = sqrt(scale * g)
    b = sqrt(scale * b)
    
    let lineString = "\(Int(255.999 * simd_clamp(r,0.0,0.999))) \(Int(255.999*simd_clamp(g,0.0,0.999))) \(Int(255.999*simd_clamp(b,0.0,0.999))) \n"
    stringOut.append(lineString)
}



func outputFile(fileContent: String){
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }


    let filename = getDocumentsDirectory().appendingPathComponent("renderNoise.ppm")

    do {
        try fileContent.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
    }

}

func reflect(v: inout Vec3,n: inout Vec3) -> Vec3{
       return simd_normalize(v) - 2 * simd_dot(v,n) * n
   }

func refract(uv: inout Vec3,n: inout Vec3, etai_over_etat: Float) -> Vec3{
    let cos_theta: Float = simd_min(simd_dot(-uv,n),1.0)
    let r_out_perp = etai_over_etat * (uv + cos_theta * n)
    let r_out_parallel = -sqrt(abs(1.0 - simd_length_squared(r_out_perp))) * n
    return r_out_perp + r_out_parallel
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}
