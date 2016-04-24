//
//  BasicAlamofireAdapter.swift
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
 Basic Alamofire adapter.
*/
public struct BasicAlamofireAdapter: AlamofireAdapter {
    
    // MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - Protocol conformance
    
    // MARK: AlamofireAdapter
    
    public func alamofireMethodForGlossMethod(method: HTTPMethod) -> Alamofire.Method {
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
    
    public func glossResultForAlamofireResponse<T>(response: Alamofire.Response<T, NSError>) -> Gloss.Result<T> {
        switch response.result {
        case .Success(let value):
            return Gloss.Result(value: value)
        case .Failure(let error):
            return Gloss.Result(error: error)
        }
    }
    
}
