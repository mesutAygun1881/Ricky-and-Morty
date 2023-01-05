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


///url icin endpoint https://rickandmortyapi.com/api/character
enum RMEndpoint : String {
    case character
    case location
    case episode
}

///errors
enum ErrorTypes : String , Error {
    case invalidData = "Invalid Data"
    case invalidUrl = "Invalid URL"
    case generalError = "An error happened"
}


class NetworkHelper {
    
    ///base url
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    private let endPoint : RMEndpoint
    private var pathComponents : [String]
    private let queryParameters : [URLQueryItem]
    public let httpMethod = "GET"
    
    /// base url e endpoint ve varsa path ve query leri ekliyoruz
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
    
    convenience init?(url : URL){
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl){
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endPointString = components[0]
                if let rmEndPoint = RMEndpoint(rawValue: endPointString){
                    self.init(endPoint: rmEndPoint)
                    return
                }
            }
        }else if trimmed.contains("?"){
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty , components.count >= 2 {
                let endPointString = components[0]
                let queryItemsString = components[1]
                //value=name&value=name
                let queryItems : [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                    
                })
                if let rmEndPoint = RMEndpoint(rawValue: endPointString){
                    self.init(endPoint: rmEndPoint , queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
    
    
    func saveToken(token : String){
        
    }
    
    
}
// bu extension ile .character veya .episode direk ulasiyoruz
extension NetworkHelper {
    static let listCharactersRequest = NetworkHelper(endPoint : .character)
}
