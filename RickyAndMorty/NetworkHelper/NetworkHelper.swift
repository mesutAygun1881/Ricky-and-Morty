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


enum RMEndpoint : String {
    case character
    case location
    case episode
}

enum ErrorTypes : String , Error {
    case invalidData = "Invalid Data"
    case invalidUrl = "Invalid URL"
    case generalError = "An error happened"
}

class NetworkHelper {
    
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    private let endPoint : RMEndpoint
    private var pathComponents : [String] = []
    private let queryParameters : [URLQueryItem]
    public let httpMethod = "GET"
    
    private var urlString : String {
        var string = Constants.baseUrl
        string += "/"
        string += endPoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach ({
                string += "/\($0)"
            })
        }
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }

        
        return string
    }
    
    public var url : URL? {
        return URL(string: urlString)
    }
    
   public init(endPoint : RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
        self.endPoint = endPoint
    }
    
    
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


extension NetworkHelper {
    static let listCharactersRequest = NetworkHelper(endPoint : .character)
}
