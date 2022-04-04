//
//  APICaller.swift
//  iTunes
//
//  Created by dorothyTao on 2022/1/4.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var description: String { get }
}
