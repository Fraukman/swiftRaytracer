//
//  Camera.swift
//  SwiftTracer
//
//  Created by Juan Souza on 15/12/20.
//  Copyright © 2020 Juan Souza. All rights reserved.
//

import Foundation
import simd

class Camera{
    private let origin: Point3
    private var lowerLeftCorner: Point3
    private let horizontal: Vec3
    private let vertical: Vec3
    private let lookfrom: Point3
    private let lookat: Point3
    private let vup: Vec3
    private let fov: Float
    private let aspect_ratio: Float
    private let aperture: Float
    private let focus_dist: Float
    private let lens_radius: Float
    let w: Vec3
    let u: Vec3
    let v: Vec3

    init(lookfrom: Vec3,lookat: Vec3,vup: Vec3, fov: Float, aspect_ratio: Float, aperture: Float, focus_dist:Float){
        self.lookfrom = lookfrom
        self.lookat = lookat
        self.vup = vup
        self.fov = fov
        self.aspect_ratio = aspect_ratio
        self.aperture = aperture
        self.focus_dist = focus_dist
    
        let theta = fov.degreesToRadians
        let h = tan(theta/2)
        let viewPortHeight:Float = 2.0 * h
        let viewPortwidth:Float = aspect_ratio * viewPortHeight
        
        w = simd_normalize(lookfrom-lookat)
        u = simd_normalize(simd_cross(vup,w))
        v = simd_cross(w,u)
        
        
        origin = lookfrom
        horizontal = focus_dist * viewPortwidth * u
        vertical = focus_dist * viewPortHeight * v
        lowerLeftCorner = origin - (horizontal/2) - (vertical/2)
        lowerLeftCorner -=  focus_dist * w
        
        lens_radius = aperture/2
    }
    
    func getRay(s: Float, t: Float) -> Ray{
        let rd: Vec3 = lens_radius * randomInUnitdisk()
        let offset: Vec3 = u * rd.x + v * rd.y
        let ray = lowerLeftCorner + s * horizontal + t * vertical
        return Ray(origin: origin+offset,direction: (ray ) - origin - offset)
    }
}
