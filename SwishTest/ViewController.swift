//
//  ViewController.swift
//  SwishTest
//
//  Created by Giovanna Cavallaro on 24/09/16.
//  Copyright © 2016 Giovanna Cavallaro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDelegate, NSURLConnectionDelegate, NSURLSessionDataDelegate {
    
    var data:NSMutableData?
    var request:NSMutableURLRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func btnRequest(sender: AnyObject) {
        self.data = NSMutableData()
        let url = NSURL(string: "http://192.168.1.9:3050/pengine/create")
        self.request = NSMutableURLRequest.init(URL: url!)
        let body:NSString = "format=json&template=prolog(A)&ask=actor(_,A,_),director(_,A)&solutions=all&src_text=:-include('movies.pl').&application=swish&chunk=10"
        //request.HTTPBody = body.dataUsingEncoding(NSASCIIStringEncoding)
        self.request!.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        
        print(self.request!.HTTPBody?.length)
        self.request!.HTTPMethod = "POST"
        request!.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request!.setValue("curl/7.43.0", forHTTPHeaderField: "User-Agent")
        //request!.setValue("application/json", forHTTPHeaderField: "Accept")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        var session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        var task = session.dataTaskWithRequest(request!)
        
        task.resume()
        print("RESUME()")
        
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("ERRORE DI CONNESSIONE")
    }
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.data!.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if((error) != nil){
            print("Hola, errori!")
        }
        print("FINITO")
        print(NSString(data: self.data!, encoding: NSUTF8StringEncoding))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

