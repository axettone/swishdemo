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
    var pullURLString:NSString?
    var pullRequest:NSMutableURLRequest?
    var pengine_id:NSString?
    
    var pullRequestHandler:PullHandler?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func btnRequest(sender: AnyObject) {
        self.data = NSMutableData()
        let url = NSURL(string: "http://192.168.1.9:3050/pengine/create")
        self.request = NSMutableURLRequest.init(URL: url!)
        
        let body:NSString = "format=json&template=prolog(Program)&ask=induce(Program)&src_text=:-include('train.pl').&application=swish&chunk=100000000000"
         self.request!.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        
        print(self.request!.HTTPBody?.length)
        self.request!.HTTPMethod = "POST"
        request!.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request!.setValue("curl/7.43.0", forHTTPHeaderField: "User-Agent")

        
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
            return
        }
        print("FINITO")
        let results:NSString = NSString(data: self.data!, encoding: NSUTF8StringEncoding)!
        let splitter:NSString = "Access-Control-Allow-Origin: *\nCache-Control: no-cache, no-store, must-revalidate\r\nPragma: no-cache\r\nExpires: 0\r\nContent-type: application/json; charset=UTF-8"
      
        //TODO: Fare pulizia, il primo array data dovrebbe essere inutile
        let tmp:NSString = results.stringByReplacingOccurrencesOfString(splitter as String, withString: ",")
        let jsonString = NSString.init(format: "{\"data\":[%@]}", tmp)
        do{
            let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            let items:NSArray = jsonData["data"] as! NSArray
            print(items.count)
            let d:NSDictionary = items[0] as! NSDictionary
            self.pengine_id = NSString(string: d["id"] as! String)
            
            self.pullResponse()
            
        } catch {
            print("Errore")
        }
        

    }
    func pullResponse(){
        self.pullRequestHandler = PullHandler(parentController: self)
        let pullURL = NSString(format: "http://192.168.1.9:3050/pengine/pull_response?id=%@&format=json", self.pengine_id!)
        //print(pullURL)
        self.pullRequest = NSMutableURLRequest.init(URL: NSURL(string: pullURL as String)!)
        self.pullRequest!.HTTPMethod = "GET"
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let anotherSession:NSURLSession = NSURLSession(configuration: config, delegate: self.pullRequestHandler!, delegateQueue: NSOperationQueue.mainQueue())
        anotherSession.dataTaskWithRequest(pullRequest!).resume()
    }
    @IBAction func pullThat(sender: AnyObject) {
        self.pullResponse()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

