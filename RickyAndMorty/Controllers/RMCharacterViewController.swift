//
//  RMCharacterViewController.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 3.01.2023.
//

import UIKit

class RMCharacterViewController: UIViewController {
   
    // MARK: PROPERTIES
    
    /// bu view icerisinde gerekli collectionview ayarlamalari yapildi
    let characterListView = RMCharacterUIView()
    
    
    // MARK: UI ELEMENTS

    
    
    // MARK: FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
       setUpView()
    }
    
    private func setUpView(){
        view.addSubview(characterListView)
        characterListView.delegate = self
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

// MARK: bu delegate collection cell icerisinde detail screene gitmek icin protokoller kullanildi
extension RMCharacterViewController :  RMCharacterUIViewDelegate  {
    // delegate function
    func rmCharacterListView(_ characterListView: RMCharacterUIView, didSelectCharacter character: RMCharacter) {
        // open detail screen for character
        
        let viewModel = RMCharacterDetailViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
