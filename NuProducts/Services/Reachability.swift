//
//  Reachability.swift
//  NuProducts
//
//  Created by Nagendra Babu on 14/02/23.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
