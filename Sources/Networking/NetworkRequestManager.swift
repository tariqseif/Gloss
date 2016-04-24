//
//  NetworkRequestManager.swift
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

import Foundation

/**
 Network request manager.
 */
public protocol NetworkRequestManager {

    /**
     Performs a network request with the provided details. Completes with empty
     tuple when successful, error otherwise.
     
     :parameter: method     Method.
     :parameter: URLString  URL string.
     :parameter: parameters Parameters.
     :parameter: headers    Headers.
     :parameter: completion Function called on completion.
     */
    func request(method: HTTPMethod, URLString: String, parameters: [String : AnyObject]?, headers: [String : String]?, completion: Result<()> -> ())
    
    /**
     Performs a network request with the provided details. Completes with
     Decodable objects when successful, error otherwise.
     
     :parameter: method     Method.
     :parameter: URLString  URL string.
     :parameter: parameters Parameters.
     :parameter: headers    Headers.
     :parameter: completion Function called on completion.
     */
    func request<T: Decodable>(method: HTTPMethod, URLString: String, parameters: [String : AnyObject]?, headers: [String : String]?, completion: Result<T> -> ())
    
    /**
     Performs a network request with the provided details. Completes with
     array of Decodable objects when successful, error otherwise.
     
     :parameter: method     Method.
     :parameter: URLString  URL string.
     :parameter: parameters Parameters.
     :parameter: headers    Headers.
     :parameter: completion Function called on completion.
     */
    func request<T: Decodable>(method: HTTPMethod, URLString: String, parameters: [String : AnyObject]?, headers: [String : String]?, completion: Result<[T]> -> ())
    
}
