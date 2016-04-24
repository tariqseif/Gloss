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
    
    // MARK: - Properties
    
    /// Adapter.
    public let adapter: AlamofireAdapter
    
    // MARK: - Init
    
    public init(adapter: AlamofireAdapter) {
        self.adapter = adapter
    }
    
    // MARK: - Protocol conformance
    
    // MARK: NetworkRequestManager
    
    public func request(method: HTTPMethod, URLString: String, parameters: [String : AnyObject]?, headers: [String : String]?, completion: Result<()> -> ()) {
        let requestMethod = adapter.alamofireMethodForGlossMethod(method)
        let responseCompletion: Response<(), NSError> -> () = { completion(self.adapter.glossResultForAlamofireResponse($0)) }
        
        request(requestMethod, URLString: URLString, parameters: parameters, encoding: .URL, headers: headers, completion: responseCompletion)
    }
    
    public func request<T: Decodable>(method: HTTPMethod, URLString: String, parameters: [String : AnyObject]?, headers: [String : String]?, completion: Gloss.Result<T> -> ()) {
        let requestMethod = adapter.alamofireMethodForGlossMethod(method)
        let responseCompletion: Response<T, NSError> -> () = { completion(self.adapter.glossResultForAlamofireResponse($0)) }
        
        request(requestMethod, URLString: URLString, parameters: parameters, encoding: .URL, headers: headers, completion: responseCompletion)
    }
    
    public func request<T : Decodable>(method: HTTPMethod, URLString: String, parameters: [String : AnyObject]?, headers: [String : String]?, completion: Gloss.Result<[T]> -> ()) {
        let requestMethod = adapter.alamofireMethodForGlossMethod(method)
        let responseCompletion: Response<[T], NSError> -> () = { completion(self.adapter.glossResultForAlamofireResponse($0)) }
        
        request(requestMethod, URLString: URLString, parameters: parameters, encoding: .URL, headers: headers, completion: responseCompletion)
    }
    
    // MARK: - Convenience functions
    
    public func request(method: Alamofire.Method, URLString: URLStringConvertible, parameters: [String : AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String : String]? = nil, completion: Alamofire.Response<(), NSError> -> ()) {
        Alamofire.request(method, URLString, parameters: parameters, encoding: encoding, headers: headers).responseGlossEmpty(completion)
    }
    
    public func request<T: Decodable>(method: Alamofire.Method, URLString: URLStringConvertible, parameters: [String : AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String : String]? = nil, completion: Alamofire.Response<T, NSError> -> ()) {
        Alamofire.request(method, URLString, parameters: parameters, encoding: encoding, headers: headers).responseGlossDecodable(completion)
    }
    
    public func request<T: Decodable>(method: Alamofire.Method, URLString: URLStringConvertible, parameters: [String : AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String : String]? = nil, completion: Alamofire.Response<[T], NSError> -> ()) {
        Alamofire.request(method, URLString, parameters: parameters, encoding: encoding, headers: headers).responseGlossDecodable(completion)
    }
    
}
