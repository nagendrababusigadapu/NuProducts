//
//  APIService.swift
//  NuProducts
//
//  Created by Nagendra Babu on 12/02/23.
//

import Foundation
import Alamofire

class APIService : NSObject {
    
    static let shared = APIService()
    
    /// overriding init to not allow other developers to create instance multiple times
    private override init() {}
    
    /// handling API reqeust
    func requestGETURL<T: Codable>(urlString:String, parameters:[String:Any]? = nil, success: @escaping ((T) -> Void), failure: @escaping ((String?) -> Void)){
        AF.request(urlString, parameters: parameters, encoding: URLEncoding.queryString).validate(statusCode: 200..<300).responseDecodable{ (response: DataResponse<T, AFError>) in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
}
