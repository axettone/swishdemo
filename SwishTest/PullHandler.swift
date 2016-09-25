//
//  PullHandler.swift
//  SwishTest
//
//  Created by Giovanna Cavallaro on 25/09/16.
//  Copyright © 2016 Giovanna Cavallaro. All rights reserved.
//

import Foundation

class PullHandler : NSObject, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLConnectionDelegate {
    var data:NSMutableData?
    var parentController:ViewController?
    
    init(parentController:ViewController) {
        self.parentController = parentController
        self.data = NSMutableData()
    }
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.data!.appendData(data)
    }
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let e=error {
            print(e.description)
        }
        let jsonString:NSString = NSString(data: self.data!, encoding: NSUTF8StringEncoding)!
        print(jsonString)
        do{
            let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            let event:NSString = jsonData["event"] as! NSString
            print(event)
            if(event != "destroy"){
                self.parentController!.pullResponse()
                return
            }
            print("Dovremmo esserci")
            self.parseSolution(jsonData)
           // let d:NSDictionary = items[0] as! NSDictionary
            
        } catch  {
            print("Errore")
        }
        print()
    }
    
    func parseSolution(data:NSDictionary){
        let l0:NSDictionary = data["data"] as!NSDictionary
        let has_more:Bool = l0["more"] as!Bool
        let event:NSString = l0["event"] as!NSString
        
        let l1:NSArray = l0["data"] as!NSArray
        
        let l2:NSDictionary = l1[0] as!NSDictionary
        
        let l3Args:NSArray = l2["args"] as!NSArray
        let l4Arr:NSArray = l3Args[0] as! NSArray
        
        let predicate:NSDictionary = l4Arr[0] as! NSDictionary
        
        /* == MAIN ITEM == */
        
        let root:Node = Node(functor: predicate["functor"] as! NSString)
        root.addChildren(predicate["args"] as! NSArray)
        
        print(root.toString())
        
    }
}