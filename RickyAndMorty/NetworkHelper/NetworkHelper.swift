//
//  NetworkHelper.swift
//  KisilerUygulamasi
//
//  Created by Mesut Aygün on 13.12.2022.
//

import Foundation
import UIKit

// MARK: 1--->> BURADA NETWORK ICIN GEREKLI OLAN YARDIMCI ELEMANLAR TANIMLANDI

enum HTTPMethods : String {
    case get = "GET"
    case post = "POST"
}




enum ErrorTypes : String , Error {
    case invalidData = "Invalid Data"
    case invalidUrl = "Invalid URL"
    case generalError = "An error happened"
}

class NetworkHelper {
    static let shared = NetworkHelper()
    
   
    
    func saveToken(token : String){
        
    }
    
  
}



// MARK: QUERIE EXTENSION

extension URL {
    func withQueries(_ queries : [String : String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map {URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}
