//
//  BaseAPIServices.swift
//  iTunes
//
//  Created by dorothyTao on 2022/2/11.
//

import Foundation
import Alamofire
import PromiseKit

class BaseAPIServices {
    private let session: Session = {
        let configuration = URLSessionConfiguration.af.default
//        configuration.timeoutIntervalForRequest = 90
//        configuration.timeoutIntervalForResource = 86400
        return Alamofire.Session(configuration: configuration)
    }()
    private let requestInterceptor: APIRequestInterceptor = {
        let interceptor = APIRequestInterceptor()
        return interceptor
    }()
    /// Base Http Request Generator
    ///
    /// - Parameters:
    ///   - request: 請求資源位置
    ///   - type: 輸入的資料模型
    public func requestNextGeneration<T: Codable>(_ request: URLRequest, type: T.Type) -> Promise<T> {
        return .init { (resolver) in
            let req = session.request(request)
            req.validate().responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    do {
                        let decoder: JSONDecoder = JSONDecoder()
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let content = try decoder.decode(type, from: jsonData)
                        log.debug(jsonString(data: jsonData))
                        resolver.fulfill(content)
                        
                    } catch let error {
                        guard let data = response.data else {
                            resolver.reject(error)
                            return
                        }
                        log.error(jsonString(data: data))
                        resolver.reject(error)
                    }
                case .failure(let error):
                    guard let data = response.data else {
                        resolver.reject(error)
                        return
                    }
                    log.error(jsonString(data: data))
                    resolver.reject(error)
                }
            }
        }
    }
}
func jsonString(data: Data) -> String {
    return String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\", with: "") ?? "nil"
}
