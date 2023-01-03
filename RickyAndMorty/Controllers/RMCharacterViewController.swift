//
//  RMCharacterViewController.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 3.01.2023.
//

import UIKit

class RMCharacterViewController: UIViewController {
    // MARK: UI ELEMENTS

    // MARK: PROPERTIES
    
    
    // MARK: FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        // Do any additional setup after loading the view.
        
        let request = NetworkHelper(endPoint: .character, queryParameters: [URLQueryItem(name: "name", value: "rick")])
      
        
        NetworkManager.shared.execute(request, type: RMCharacter.self) { result in
            switch result {
            case .success :
                break
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    

  

}
