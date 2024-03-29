//
//  s3Manager.swift
//  dbManager
//
//  Created by guest on 7/28/16.
//  Copyright © 2016 guest. All rights reserved.
//

import Foundation
import AWSS3
import Bolts


public class s3Manager:NSObject {
    public static let  s3Intance = AWSS3TransferManager.defaultS3TransferManager()
    public static var  Datas:[NSData?] = [NSData?](count:120,repeatedValue:nil)
    public static let S3BucketName:String = "com.berbi.health.photo2"
    class func download(){
        
    }
    public class func createDirectory(name:String){
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(
                NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(name),
                withIntermediateDirectories: true,
                attributes: nil)
        } catch {
            print("Creating 'download' directory failed. Error: \(error)")
        }
    }
    public class func download(BucketName: String,downloadRequests: [String])->[NSData?] {
        let transferUtility = AWSS3TransferUtility.defaultS3TransferUtility()
        var Tasks:[BFTask] = [BFTask]()
        //var Datas:[NSData?] = [NSData?](count:downloadRequests.count,repeatedValue:nil)
        var Progresses:[Float] = [Float](count:downloadRequests.count,repeatedValue:0.0)
        let expression = AWSS3TransferUtilityDownloadExpression()
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        print("start time:",NSDate().description)
        for i in 0..<3{
            //print("i is \(i)")
            var request = downloadRequests[i]
            let taskCompletionSource = BFTaskCompletionSource()
            completionHandler = { (task, location, data, error) -> Void in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    if ((error) != nil){
                        NSLog("Failed with error")
                        NSLog("Error: %@",error!);
                        taskCompletionSource.setError(error!)
                    }
                        //else if(self.progressView.progress != 1.0) {
                        //  self.statusLabel.text = "Failed"
                        //NSLog("Error: Failed - Likely due to invalid region / filename")
                        //}
                    else{
                        //print("i for data is \(i)")
                        taskCompletionSource.setResult("Data[\(i)] successfully")
                        self.Datas[i] = data!
                    }
                })
            }
            transferUtility.downloadDataFromBucket(
                BucketName,
                key: request,
                expression: nil,
                completionHander: completionHandler)
            Tasks.append(taskCompletionSource.task)
        }
        print("tasks length \(Tasks.count)")
        var Task_t = BFTask.init(forCompletionOfAllTasks: Tasks)
        Task_t.waitUntilFinished()
        print("end time:",NSDate().description)
        if(Datas[0] != nil){
            print("Datas[0] not nil")
        }else{
            assert(false,"Function: \(#function), line: \(#line)")
        }
        return self.Datas
    }
    /*class func toTask(task:AWSTask,)->Task<AWSTask>{
     let transferUtility = AWSS3TransferUtility.defaultS3TransferUtility()
     let taskCompletionSource = TaskCompletionSource<AWSTask>()
     task.continueWithBlock({
     (task)->AnyObject! in
     if(task.error != nil){
     taskCompletionSource.setError(task.error!)
     }else{
     self.Datas[i] = data!
     taskCompletionSource.setResult(task)
     }
     return nil
     })
     return taskCompletionSource.task
     }*/
    public class func listObjects() {
        let s3 = AWSS3.defaultS3()
        var Requests:[String] = [String]()
        let listObjectsRequest = AWSS3ListObjectsRequest()
        listObjectsRequest.bucket = S3BucketName
        s3.listObjects(listObjectsRequest).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                print("listObjects failed: [\(error)]")
            }
            if let exception = task.exception {
                print("listObjects failed: [\(exception)]")
            }
            if let listObjectsOutput = task.result as? AWSS3ListObjectsOutput {
                if let contents = listObjectsOutput.contents {
                    for s3Object in contents {
                        Requests.append(s3Object.key!)
                    }
                }
                print("Request[0]: \(Requests[0])")
                var Datas = download(S3BucketName, downloadRequests: Requests)
                print("count: \(Datas.count)")
                print("byte length: \(Datas[0]!.length)")
                //print("byte length: \(Datas[100]!.length)")
                
            }
            return nil
        }
    }
}