//
//  ProductsViewModel.swift
//  NuProducts
//
//  Created by Nagendra Babu on 12/02/23.
//

import Foundation

class ProductsViewModel {
    
    private let productsUrlPath = "https://dummyjson.com/products"
    private var productList:ProductList? = nil
    
    /// fetch data from api
    func fetchData(completion : @escaping (_ isSuccess: Bool,_ error:String?) -> Void){
        APIService.shared.requestGETURL(urlString: productsUrlPath, parameters: nil) { [weak self] (response:ProductList) in
            let status = self?.updateResponse(response: response)
            if status ?? false {
                completion(true,nil)
            }else{
                completion(false,"")
            }
        } failure: { (message) in
            completion(false, message)
        }
    }
}


extension ProductsViewModel {
    
    func updateResponse(response:ProductList?) -> Bool {
        guard let response = response else { return false }
        productList = response
        return true
    }
    
}
