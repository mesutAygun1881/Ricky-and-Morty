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
    
    /// bu view icerisinde gerekli collectionview ayarlamalari yapildi
    let characterListView = CharacterListView()
    
    // MARK: FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
       setUpView()
    }
    
    private func setUpView(){
        view.addSubview(characterListView)
        addConstraints()
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }


  

}
