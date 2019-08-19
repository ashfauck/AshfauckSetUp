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
    static public let environment:NBNetworkEnvironment = .test
    #elseif Stage
    //    // Stage environment
    static public let environment:NBNetworkEnvironment = .staging
    #else
    //    // Release environment
    static public let environment:NBNetworkEnvironment = .release
    #endif
    
    static public var accessToken:String = ""
    static public var environmentBaseURL:String {
        
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
