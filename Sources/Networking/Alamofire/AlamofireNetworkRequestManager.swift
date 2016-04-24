//
//  AlamofireNetworkRequestManager.swift
//  Gloss
//
// Copyright (c) 2016 Harlan Kellaway
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Alamofire
import Foundation

/**
 Alamofire network request manager.
 */
public struct AlamofireNetworkRequestManager: NetworkRequestManager {
    
    // MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - Convenience functions
    
    public func networkRequest<T: Decodable>(method: Gloss.Method, URLString: URLStringConvertible, parameters: [String : AnyObject]? = nil, headers: [String : String]? = nil, completion: Result<T, NSError> -> ()) {
        let completion: (value: T?, error: NSError?) -> () = {
            (object, error) in
            
            if let error = error {
                completion(.Failure(error))
                return
            }
            
            completion(.Success(object!))
        }
        
        networkRequest(method, URLString: URLString.URLString, parameters: parameters, headers: headers, completion: completion)
    }
    
    public func networkRequest<T: Decodable>(method: Gloss.Method, URLString: URLStringConvertible, parameters: [String : AnyObject]? = nil, headers: [String : String]? = nil, completion: Result<[T], NSError> -> ()) {
        let completion: (value: [T]?, error: NSError?) -> () = {
            (objects, error) in
            
            if let error = error {
                completion(.Failure(error))
                return
            }
            
            completion(.Success(objects!))
        }
        
        networkRequest(method, URLString: URLString.URLString, parameters: parameters, headers: headers, completion: completion)
    }
    
    // MARK: - Protocol conformance
    
    // MARK: NetworkRequestManager
    
    public func networkRequest<T: Decodable>(method: Gloss.Method, URLString: String, parameters: [String : AnyObject]?, headers: [String : String]?, completion: (value: T?, error: NSError?) -> ()) {
        let requestMethod = alamofireMethodForMethod(method)
        
        let responseCompletion: Response<T, NSError> -> () = {
            response in
            
            switch response.result {
            case .Success(let value):
                completion(value: value, error: nil)
            case .Failure(let error):
                completion(value: nil, error: error)
            }
        }
        
        Alamofire.request(requestMethod, URLString, parameters: parameters, encoding: .URL, headers: headers).responseDecodable(responseCompletion)
    }
    
    public func networkRequest<T : Decodable>(method: Gloss.Method, URLString: String, parameters: [String : AnyObject]?, headers: [String : String]?, completion: (value: [T]?, error: NSError?) -> ()) {
        let requestMethod = alamofireMethodForMethod(method)
        
        let responseCompletion: Response<[T], NSError> -> () = {
            response in
            
            switch response.result {
            case .Success(let value):
                completion(value: value, error: nil)
            case .Failure(let error):
                completion(value: nil, error: error)
            }
        }
        
        Alamofire.request(requestMethod, URLString, parameters: parameters, encoding: .URL, headers: headers).responseDecodable(responseCompletion)
    }
    
    // MARK: - Private functions
    
    private func alamofireMethodForMethod(method: Gloss.Method) -> Alamofire.Method {
        switch method {
        case .CONNECT:
            return Alamofire.Method.CONNECT
        case .DELETE:
            return Alamofire.Method.DELETE
        case .GET:
            return Alamofire.Method.GET
        case .HEAD:
            return Alamofire.Method.HEAD
        case .OPTIONS:
            return Alamofire.Method.OPTIONS
        case .PATCH:
            return Alamofire.Method.PATCH
        case .POST:
            return Alamofire.Method.POST
        case .PUT:
            return Alamofire.Method.PUT
        case .TRACE:
            return Alamofire.Method.TRACE
        }
    }
    
}
