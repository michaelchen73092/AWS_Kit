//
//  testB.swift
//  AWS_Kit
//
//  Created by guest on 8/3/16.
//  Copyright © 2016 guest. All rights reserved.
//

import Foundation
import Bolts
import AWSDynamoDB

public class testB:NSObject {
    public func isDoctor()->BFTask{
        var taskcompletion = BFTaskCompletionSource()
        
        return taskcompletion.task
    }
}
