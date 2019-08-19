//
//  NBNetworkResponse.swift
//  Neobone
//
//  Created by Ashfauck Thaminsali on 4/25/19.
//  Copyright © 2019 ORGware. All rights reserved.
//

import UIKit

enum NBNetworkResponse:Error {
    case success
    case authenticationError
    case badRequest
    case notFound
    case outdated
    case requestFailed
    case noData
    case unableToDecode
    case networkFailed
    case commonError
    
    var detail:String {
        
        switch self {
        case .success:
            return "Success".localized()
        case .authenticationError:
            return "You need to be authenticated first.".localized()
        case .badRequest:
            return  "Bad request".localized()
        case .outdated:
            return "The url you requested is outdated."
        case .requestFailed:
            return "Network request failed.".localized()
        case .notFound:
            return "Not found".localized()
        case .noData:
            return "Response returned with no data to decode.".localized()
        case .unableToDecode:
            return "We could not decode the response.".localized()
        case .networkFailed:
            return "Unable to connect to the internet".localized()
        case .commonError:
            return self.localizedDescription
        }
        
    }
    
}

extension HTTPURLResponse
{
    func verifyResponse() -> ResponseCheck<String>
    {
        switch self.statusCode
        {
        case 200...299:
            return .success
        case 400:
            return .failure(NBNetworkResponse.badRequest.detail)
        case 404:
            return .failure(NBNetworkResponse.notFound.detail)
        case 401...500:
            return .failure(NBNetworkResponse.authenticationError.detail)
        case 501...599:
            return .failure(NBNetworkResponse.badRequest.detail)
        case 600:
            return .failure(NBNetworkResponse.outdated.detail)
        default:
            return .failure(NBNetworkResponse.requestFailed.detail)
        }
    }
}

enum ResponseCheck<String>
{
    case success
    case failure(String)
}
