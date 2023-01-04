//
//  RMCharacterStatus.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 3.01.2023.
//

import Foundation



enum RMCharacterStatus : String, Codable {
case alive = "Alive"
case dead = "Dead"
case unknown = "Unknown"
    
    var text : String {
        switch self {
        case .alive , .dead :
            return rawValue
        case .unknown :
            return "Unknown"
        }
        
    }
}
