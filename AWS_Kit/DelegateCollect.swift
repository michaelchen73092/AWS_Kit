//
//  DelegateCollect.swift
//  AWS_Kit
//
//  Created by guest on 8/3/16.
//  Copyright © 2016 guest. All rights reserved.
//

import Foundation

class DelegateCollect: NSObject,NSURLSessionDelegate {
    public static let instance:DelegateCollect = DelegateCollect()
    // Mark: NSURLSession Delegate
    
    internal func URLSession(session: NSURLSession,didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition,NSURLCredential?) -> Void){
        
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
    
}