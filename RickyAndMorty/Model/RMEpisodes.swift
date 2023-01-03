//
//  Episodes.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 3.01.2023.
//

import Foundation


struct RMEpisodes : Codable {
    let id : Int
    let name : String
    let air_date : String
    let episode : String
    let characters : [String]
    let url : String
    let created : String
}
