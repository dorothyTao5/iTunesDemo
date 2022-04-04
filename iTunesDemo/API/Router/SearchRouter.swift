//
//  SearchRouter.swift
//  iTunes
//
//  Created by dorothyTao on 2022/2/12.
//

import Foundation
import Alamofire

enum SearchRouter: APIConfiguration {
    case getSearch(input: SearchInput)

    var method: HTTPMethod {
        switch self {
        case .getSearch:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getSearch:
            return "/search"
        }
    }
    
    var description: String {
        switch self {
        case .getSearch:
            return " search "
       }
    }

    func asURLRequest() throws -> URLRequest {
        let url = APIConstants.Server.baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method

        log.info(description)

        switch self {
        case let .getSearch(input):
            request = try URLEncodedFormParameterEncoder().encode(input, into: request)
        }
        return request
    }
}
