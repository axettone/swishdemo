//
//  Node.swift
//  SwishTest
//
//  Created by Paolo N. Giubelli on 25/09/16.
//  Copyright © 2016 Paolo N. Giubelli. All rights reserved.
//

import Foundation

class Node : NSObject {
    var functor: NSString
    var args: [Node] = []
    var parent:Node?
    
    init(functor: NSString) {
        self.functor = functor
    }
    
    func addChild(node:Node){
        args.append(node)
        node.parent = self
    }
    
    func addChildren(args:NSArray){
        for arg in args {
            
            if(arg.isKindOfClass(NSString)){
                let n:Node = Node(functor: arg as! NSString)
                self.addChild(n)
            } else if (arg.isKindOfClass(NSDictionary)){
                let n:Node = Node(functor: arg["functor"] as! NSString)
                n.addChildren(arg["args"] as! NSArray)
                self.addChild(n)
            }
        }
    }
    func isLeaf() -> Bool {
        return self.args.count == 0
    }
    func argstoString() -> [String] {
        var ret:[String] = [String]()
        for arg:Node in self.args {
            ret.append(arg.toString())
        }
        return ret
    }
    func toString() -> String{
        if(self.functor == "," || self.functor == ":-"){
            let tmp:[String] = self.argstoString()
            return tmp.joinWithSeparator(self.functor as String)
        }  else {
            if(self.isLeaf()){
                return self.functor as String
            }   else {
                return NSString.init(format: "%@(%@)", self.functor, self.argstoString().joinWithSeparator(",")) as String
            }
        }
    }
}