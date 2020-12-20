//
//  main.swift
//  SwiftTracer
//
//  Created by Juan Souza on 13/12/20.
//  Copyright © 2020 Juan Souza. All rights reserved.
//

import Foundation
import simd


func randomScene() -> HittableList{
    let ground_material = Lambertian(albedo: Color3(0.5,0.5,0.5))
    let world: HittableList = HittableList(objects: [Sphere(center: Point3(0,-1000,0), radius: 1000, mat_ptr: ground_material)])
   
    
    for a in -5...5 {
        for b in -5...5{
            let choose_mat = random01()
            let center = Point3(Float(a) + 0.9 * random01(),0.2,Float(b)+0.9*random01())
            
            if(simd_length(center - Point3(4,0.2,0))>0.9){
                let sphere_material: Material
                
                if(choose_mat < 0.8){
                    let albedo = Color3(random01(),random01(),random01()) * Color3(random01(),random01(),abs(random01() - 0.7))
                    sphere_material = Lambertian(albedo: albedo)
                    world.add(object: Sphere(center: center, radius: 0.2, mat_ptr: sphere_material))
                    //let albedo = Color3(Float.random(in: 0.5...1))
                }
               else if(choose_mat < 0.95){
                    let albedo = Color3(abs(random01() - 0.5),abs(random01() - 0.5),abs(random01() - 0.7))
                    sphere_material = Metal(albedo: albedo)
                    world.add(object: Sphere(center: center, radius: 0.2, mat_ptr: sphere_material))
                    //let albedo = Color3(Float.random(in: 0.5...1))
                }
                else {
                    sphere_material = Dielectric(ir: 1.5)
                    world.add(object: Sphere(center: center, radius: 0.2, mat_ptr: sphere_material))
                    //let albedo = Color3(Float.random(in: 0.5...1))
                }
                
            }
        }
    }
    
    let material1 = Dielectric(ir: 1.5)
    world.add(object: Sphere(center: Point3(0,1,0), radius: 1.0, mat_ptr: material1))
    
    let material2 = Lambertian(albedo: Color3(0.4,0.2,0.4))
    world.add(object: Sphere(center: Point3(-4,1,0), radius: 1, mat_ptr: material2))
    
    let material3 = Metal(albedo: Color3(0.7,0.6,0.5))
    world.add(object: Sphere(center: Point3(4,1,0), radius: 1, mat_ptr: material3))
    
    return world
}


//MARK: - Image

let aspect_ratio: Float = 3.0 / 2.0
let image_width = 560
let image_height = Int(Float(image_width)/aspect_ratio)
let samplesPerPixel = 50
let max_depth = 100


//MARK: - World



//var world = randomScene()
let material1 = Lambertian(albedo: Color3(0.4,0.2,0.4))
let ground_material = Lambertian(albedo: Color3(0,0.5,0.5))
var world = HittableList(objects: [Sphere(center: Point3(0.5,0,-10), radius: 1.0, mat_ptr: material1)])
//world.add(object: Sphere(center: Point3(0,-1000,0), radius: 1000, mat_ptr: ground_material))  Dielectric(ir: 1.5)
let material2 = Metal(albedo: Color3(0.7,0.6,0.5))
world.add(object: Sphere(center: Point3(0,0,-200), radius: 100, mat_ptr: material2))
world.add(object: Sphere(center: Point3(0,0,200), radius: 100, mat_ptr: material2))

//MARK: - Camera

//Point3(13,2,3)
let cam = Camera(lookfrom: Point3(5,0,10), lookat: Point3(0.5,0,-10), vup: Vec3(0,1,0), fov: 20, aspect_ratio: aspect_ratio, aperture: 0.1, focus_dist: 10.0)

//MARK: - Render

let raytracingQueue = OperationQueue()
raytracingQueue.name = "com.ceroce.SwiftRay Raytracing1"
let raytracingQueue2 = OperationQueue()
raytracingQueue2.name = "com.ceroce.SwiftRay Raytracing2"
let raytracingQueue3 = OperationQueue()
raytracingQueue3.name = "com.ceroce.SwiftRay Raytracing3"
let raytracingQueue4 = OperationQueue()
raytracingQueue4.name = "com.ceroce.SwiftRay Raytracing4"

let startDAte = Date()

var str = "P3\n\(image_width) \(image_height)\n255\n"
var str1 = ""
var str2 = ""
var str3 = ""
var str4 = ""

raytracingQueue.addOperation {
    for j in (0..<image_height/4).reversed(){
        print("\rScanlines remaining T1: \((image_height/4) - j)")
        for i in (0...(image_width-1)) {
            var pixelColor = Color3(0,0,0)
            for _ in 0...samplesPerPixel - 1{
                let u = (Float(i) + random01()) / Float(image_width - 1)
                let v = (Float(j) + random01()) / Float(image_height - 1)
                var r = cam.getRay(s: u, t: v)
                pixelColor += rayColor(r: &r, world: &world, depth: max_depth)
                 
            }
           writeColor(stringOut: &str1, pixelColor: pixelColor, samplesPerPixel: samplesPerPixel)
            
        }
    }
}
raytracingQueue2.addOperation {
    for j in (image_height/4...image_height/2).reversed(){
        print("\rScanlines remaining T2: \((image_height/2) - j)")
        for i in (0...(image_width-1)) {
            var pixelColor = Color3(0,0,0)
            for _ in 0...samplesPerPixel - 1{
                let u = (Float(i) + random01()) / Float(image_width - 1)
                let v = (Float(j) + random01()) / Float(image_height - 1)
                var r = cam.getRay(s: u, t: v)
                pixelColor += rayColor(r: &r, world: &world, depth: max_depth)
                 
            }
           writeColor(stringOut: &str2, pixelColor: pixelColor, samplesPerPixel: samplesPerPixel)
            
        }
    }
}

raytracingQueue3.addOperation {
    for j in (image_height/2...((image_height/2)+(image_height/4))).reversed(){
        print("\rScanlines remaining T3: \((((image_height/2)+(image_height/4))) - j)")
        for i in (0...(image_width-1)) {
            var pixelColor = Color3(0,0,0)
            for _ in 0...samplesPerPixel - 1{
                let u = (Float(i) + random01()) / Float(image_width - 1)
                let v = (Float(j) + random01()) / Float(image_height - 1)
                var r = cam.getRay(s: u, t: v)
                pixelColor += rayColor(r: &r, world: &world, depth: max_depth)
                 
            }
           writeColor(stringOut: &str3, pixelColor: pixelColor, samplesPerPixel: samplesPerPixel)
            
        }
    }
}

raytracingQueue4.addOperation {
    for j in (((image_height/2)+(image_height/4))...((image_height))).reversed(){
        print("\rScanlines remaining T4: \(image_height - j)")
        for i in (0...(image_width-1)) {
            var pixelColor = Color3(0,0,0)
            for _ in 0...samplesPerPixel - 1{
                let u = (Float(i) + random01()) / Float(image_width - 1)
                let v = (Float(j) + random01()) / Float(image_height - 1)
                var r = cam.getRay(s: u, t: v)
                pixelColor += rayColor(r: &r, world: &world, depth: max_depth)
                 
            }
           writeColor(stringOut: &str4, pixelColor: pixelColor, samplesPerPixel: samplesPerPixel)
            
        }
    }
}

while (raytracingQueue.operationCount > 0) ||
    (raytracingQueue2.operationCount > 0) ||
    (raytracingQueue3.operationCount > 0) ||
    (raytracingQueue4.operationCount > 0){
}

str.append(str4)
str.append(str3)
str.append(str2)
str.append(str1)
outputFile(fileContent: str)

let renderingDuration = Date().timeIntervalSince(startDAte)
print("Image rendered in \(renderingDuration) s.")


