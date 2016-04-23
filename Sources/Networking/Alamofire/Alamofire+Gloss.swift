//
//  Alamofire+Gloss.swift
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
import Gloss
import Foundation

// MARK: - Convenience functions

extension Request {
    
    /**
     Handler for Response with a Decodable object.
     
     completion: Handler for Response with a Decodable object.
     */
    public func responseDecodable<T: Decodable>(completion: Response<T, NSError> -> Void) -> Self {
        return response(responseSerializer: Request.DecodableJSONResponseSerializer(), completionHandler: completion)
    }
    
    /**
     Handler for Response with array of Decodable objects.
     
     completion: Handler for Response with array of Decodable objects.
     */
    public func responseDecodable<T: Decodable>(completion: Response<[T], NSError> -> Void) -> Self {
        return response(responseSerializer: Request.DecodableJSONResponseSerializer(), completionHandler: completion)
    }
    
    /**
     Response serializer capable of serializing a Decodable object.
     
     :returns: Response serializer.
     */
    public static func DecodableJSONResponseSerializer<T: Decodable>() -> ResponseSerializer<T, NSError> {
        let responseSerializer = ResponseSerializer<T, NSError> {
            (request, response, data, error) in
            
            let result: Result<T, NSError> = self.serializeResponse(request, response: response, data: data, error: error, options: .AllowFragments)
            
            return result
        }
        
        return responseSerializer
    }
    
    /**
     Response serializer capable of serializing arrays of Decodbable objects.
     
     :returns: Response serializer.
     */
    public static func DecodableJSONResponseSerializer<T: Decodable>() -> ResponseSerializer<[T], NSError> {
        let responseSerializer = ResponseSerializer<[T], NSError> {
            (request, response, data, error) in
            
            let result: Result<[T], NSError> = self.serializeResponse(request, response: response, data: data, error: error, options: .AllowFragments)
            
            return result
        }
        
        return responseSerializer
    }
    
    /**
     Serializes a response into a Decodable object. Returns serialized object
     when successful, error otherwise.
     
     :parameter: request  Request.
     :parameter: response Response.
     :parameter: data     Data.
     :parameter: error    Error.
     
     :returns: Result of serializing response to Decodable object.
     */
    public static func serializeResponse<T: Decodable>(request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?, options: NSJSONReadingOptions?) -> Result<T, NSError> {
        let result: (T?, NSError?) = serializeResponse(request, response: response, data: data, error: error, options: options)
        
        if let error = result.1 {
            return .Failure(error)
        }
        
        return .Success(result.0!)
    }
    
    /**
     Serializes a response into an array of Decodable objects. Returns serialized objects
     when successful, error otherwise.
     
     :parameter: request  Request.
     :parameter: response Response.
     :parameter: data     Data.
     :parameter: error    Error.
     
     :returns: Result of serializing response to array of Decodable objects.
     */
    public static func serializeResponse<T : Decodable>(request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?, options: NSJSONReadingOptions?) -> Result<[T], NSError> {
        let result: ([T]?, NSError?) = serializeResponse(request, response: response, data: data, error: error, options: options)
        
        if let error = result.1 {
            return .Failure(error)
        }
        
        return .Success(result.0!)
    }
    
}

// MARK: - Protocol conformance

// MARK: DecodableResponseSerializer

extension Request: DecodableResponseSerializer {
    
    public static func serializeResponse<T: Decodable>(request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?, options: NSJSONReadingOptions?) -> (value: T?, error: NSError?) {
        let jsonResponseSerializer: ResponseSerializer<AnyObject, NSError> = (options == nil) ? Request.JSONResponseSerializer() : Request.JSONResponseSerializer(options: options!)
        let result = jsonResponseSerializer.serializeResponse(request, response, data, error)
        
        switch result {
        case .Success(let value):
            if
                let json = value as? JSON,
                let responseObject = T(json: json) {
                return (responseObject, nil)
            } else {
                let failureReason = "JSON could not be serialized into response object: \(value)"
                let error = NSError(domain: "com.harlankellaway.Gloss", code: 1, userInfo: [NSLocalizedDescriptionKey : failureReason])
                
                return (nil, error)
            }
        case .Failure(let error):
            return (nil, error)
        }
    }
    
    public static func serializeResponse<T : Decodable>(request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?, options: NSJSONReadingOptions?) -> (value: [T]?, error: NSError?) {
        let jsonResponseSerializer: ResponseSerializer<AnyObject, NSError> = (options == nil) ? Request.JSONResponseSerializer() : Request.JSONResponseSerializer(options: options!)
        let result = jsonResponseSerializer.serializeResponse(request, response, data, error)
        
        switch result {
        case .Success(let value):
            if
                let jsonArray = value as? [JSON] {
                let responseObject = [T].fromJSONArray(jsonArray)
                
                return (responseObject, nil)
            } else {
                let failureReason = "JSON could not be serialized into response object: \(value)"
                let error = NSError(domain: "com.harlankellaway.Gloss", code: 1, userInfo: [NSLocalizedDescriptionKey : failureReason])
                
                return (nil, error)
            }
        case .Failure(let error):
            return (nil, error)
        }
    }
    
}
