//
//  RMCharacterCollectionCellViewModel.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 4.01.2023.
//

import Foundation


final class RMCharacterCollectionCellViewModel : Hashable ,Equatable {
    static func == (lhs: RMCharacterCollectionCellViewModel, rhs: RMCharacterCollectionCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    

    
    public let characterName : String
    private let characterStatus : RMCharacterStatus
    private let characterImage : URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImage)
    }
    
    init(
        characterName : String,
        characterStatus : RMCharacterStatus,
        characterImage : URL?
    
    ){
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImage = characterImage
    }
    public var characterStatusText : String {
        return "Status :\(characterStatus.rawValue)"
    }
    
    
    // MARK: FETCH COLLECTION CELL IMAGE
    public func fetchImage(completion : @escaping (Result<Data , Error>) -> Void){
        guard let url = characterImage else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data , error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
