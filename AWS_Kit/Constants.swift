//
//  Constants.swift
//  AWS_Kit
//
//  Created by guest on 8/3/16.
//  Copyright © 2016 guest. All rights reserved.
//


import Foundation
class Constans{
    class func hashDict(key:String)->[String]?{
        let dict:[String:[String]] = ["Doctors":["firstname","email"],"Persons":["firstname","email"],"Test2":["email","id"]]
        if(dict.keys.contains(key)){
            return dict[key]
        }
        return ["day","time"]
    }
    class func igonredDict(key:String)->Set<String>?{
        var set:[String:Set<String>] = ["Persons":["imageLocal"],"Doctors":["doctorImageDiploma","doctorImageID","doctorImageMedicalLicense","doctorImageSpecialistLicense"]]
        if(set.keys.contains(key)){
            return set[key]
        }
        return nil
    }
}