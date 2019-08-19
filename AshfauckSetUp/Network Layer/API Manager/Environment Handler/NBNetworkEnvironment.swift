//
//  NBNetworkEnvironment.swift
//  Neobone
//
//  Created by Ashfauck Thaminsali on 4/25/19.
//  Copyright © 2019 ORGware. All rights reserved.
//

import UIKit

public enum NBNetworkEnvironment
{
    case release
    case staging
    case test
}

public struct EnvironmentManager
{
    #if Test
    //    // Test environment
    static let environment:NBNetworkEnvironment = .test
    #elseif Stage
    //    // Stage environment
    static let environment:NBNetworkEnvironment = .staging
    #else
    //    // Release environment
    static let environment:NBNetworkEnvironment = .release
    #endif
    
    static var accessToken:String = ""
    static var environmentBaseURL:String {
        
        switch EnvironmentManager.environment
        {
        case .release:
            return ""
        case .staging:
            return ""
        case .test:
            return ""
        }
        
    }
    
}
