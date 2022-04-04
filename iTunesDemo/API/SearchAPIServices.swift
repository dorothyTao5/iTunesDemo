//
//  SearchAPIServices.swift
//  iTunes
//
//  Created by dorothyTao on 2022/2/12.
//

import Foundation
import PromiseKit
import Alamofire

class SearchAPIServices: BaseAPIServices {
    static let sharedInstance = SearchAPIServices()
    
    func getSearch(input: SearchInput) -> Promise<SearchOutput> {
        return .init { (resolver) in
            do {
                let request = try SearchRouter.getSearch(input: input).asURLRequest()
                firstly {
                    requestNextGeneration(request, type: SearchOutput.self)
                }.done { data in
                    resolver.fulfill(data)
                }.catch { (error) in
                    resolver.resolve(nil, error)
                }
            } catch {
                resolver.reject(error)
            }
        }
    }
}
