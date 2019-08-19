//
//  NBRequestSchema.swift
//  Neobone
//
//  Created by Ashfauck Thaminsali on 4/25/19.
//  Copyright © 2019 ORGware. All rights reserved.
//

import UIKit

protocol NBRequestSchema {
    var baseURL : URL { get }
    var path : String { get }
    var httpMethod : NBHttpMethod { get }
    var task : NBRequestTaskType { get }
    var headers : NBHTTPHeaders? { get }
}
