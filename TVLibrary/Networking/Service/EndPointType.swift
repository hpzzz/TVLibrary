//
//  Endpoint.swift
//  TVLibrary
//
//  Created by Karol Harasim on 21/11/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation
protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
