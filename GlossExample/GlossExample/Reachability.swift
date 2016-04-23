//
//  Reachability.swift
//  GlossExample
//
//  Created by Harlan Kellaway on 4/23/16.
//  Copyright © 2016 Harlan Kellaway. All rights reserved.
//

import Foundation

protocol Reachability {
    
    /// Whether the Internet is reachable.
    func isReachable() -> Bool
    
}

struct BasicReachability: Reachability {
    
    func isReachable() -> Bool {
        let reachabilityCheckURL = NSURL(string: "https://google.com/")
        let reachabilityRequest = NSMutableURLRequest(URL: reachabilityCheckURL!)
        
        reachabilityRequest.HTTPMethod = "HEAD"
        reachabilityRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        reachabilityRequest.timeoutInterval = 5.0
        
        var response: NSURLResponse?
        
        do {
            try NSURLConnection.sendSynchronousRequest(reachabilityRequest, returningResponse: &response)
        } catch {
            return false
        }
        
        if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
            return true
        }
        
        return false
    }
}
