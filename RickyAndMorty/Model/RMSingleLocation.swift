//
//  RMSingleLocation.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 3.01.2023.
//

import Foundation


struct RMSingleLocation : Codable {
    let id : Int
    let name : String
    let type : String
    let dimension : String
    let residents : [String]
    let url : String
    let created : String
}
