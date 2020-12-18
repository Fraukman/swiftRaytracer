//
//  HittableList.swift
//  SwiftTracer
//
//  Created by Juan Souza on 14/12/20.
//  Copyright © 2020 Juan Souza. All rights reserved.
//

import Foundation

class HittableList: Hittable{
    var objects:[Hittable]
    
    init(objects:[Hittable]) {
        self.objects = objects
    }
      
    func clear(){
        objects.removeAll()
    }
    
    func add(object: Hittable){
        objects.append(object)
    }
    
    override func hit(r: inout Ray,t_min: Float,t_max:Float,rec: inout hit_record)->Bool{
        var temp_rec: hit_record = hit_record(p: Point3(0,0,0), normal: Vec3(0,0,0), t: 0, front_face: false, mat_ptr: nil)
        var hit_anything = false
        var closest_so_far = t_max
        
        for object in objects{
            if(object.hit(r: &r,t_min: t_min,t_max: closest_so_far,rec: &temp_rec)){
                hit_anything = true;
                closest_so_far = temp_rec.t
                rec = temp_rec
            }
        }
        return hit_anything
    }
}
