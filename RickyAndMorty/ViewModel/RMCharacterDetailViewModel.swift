//
//  RMCharacterDetailViewModel.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 4.01.2023.
//

import Foundation


class RMCharacterDetailViewModel {
    
    private let character : RMCharacter
    
    init(character : RMCharacter){
        self.character = character
    }
    
    public var title : String {
        character.name.uppercased()
    }
}
