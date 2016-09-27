//
//  ViewController.swift
//  SwishTest
//
//  Created by Paolo N. Giubelli on 24/09/16.
//  Copyright © 2016 Paolo N. Giubelli. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDelegate, NSURLConnectionDelegate, NSURLSessionDataDelegate {
    
    var data:NSMutableData?
    var request:NSMutableURLRequest?
    var pullURLString:NSString?
    var pullRequest:NSMutableURLRequest?
    var pengine_id:NSString?
    
    var pullRequestHandler:PullHandler?
    
    
    @IBOutlet weak var lblTheory: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func btnRequest(sender: AnyObject) {
        self.data = NSMutableData()
        let url = NSURL(string: "http://192.168.1.10:3050/pengine/create")
        self.request = NSMutableURLRequest.init(URL: url!)
        
        //print(self.request!.HTTPBody?.length)
        self.request!.HTTPMethod = "POST"
        request!.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request!.setValue("curl/7.43.0", forHTTPHeaderField: "User-Agent")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        var session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        do{
            let fileURL:String = "https://raw.githubusercontent.com/axettone/swish/master/examples/aleph/train.pl"
            let body:NSString = "format=json&template=prolog(Program)&ask=induce(Program)&src_url=\(fileURL)&application=swish&chunk=100000000000"
            self.request!.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
            var task = session.dataTaskWithRequest(request!)
            task.resume()
        } catch {
            print("ERRORE")
        }
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

        let jsonString = NSString(data: self.data!, encoding: NSUTF8StringEncoding)!
        do{
            let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            self.pengine_id = NSString(string: jsonData["id"] as! String)
            self.pullResponse()
            
        } catch {
            print("Errore")
        }
        

    }
    func pullResponse(){
        self.pullRequestHandler = PullHandler(parentController: self)
        let pullURL = NSString(format: "http://192.168.1.10:3050/pengine/pull_response?id=%@&format=json", self.pengine_id!)
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
    
    func updateGUI(theory:NSString){
        self.lblTheory.text = theory as String
    }


}

