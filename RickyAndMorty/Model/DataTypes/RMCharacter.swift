//
//  Characters.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 3.01.2023.
//

import Foundation


struct RMCharacter : Codable {
    let id : Int
    let name : String
    let status : RMCharacterStatus.RawValue
    let species : String
    let type : String
    let gender : RMCharacterGender.RawValue
    let origin : RMOrigin
    let location : RMSingleLocation
    let image : String
    let episode : [String]
    let url : String
    let created : String
}
