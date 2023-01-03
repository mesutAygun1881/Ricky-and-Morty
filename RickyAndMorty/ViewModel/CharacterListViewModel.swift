//
//  CharacterListViewModel.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 3.01.2023.
//

import UIKit


class CharacterListViewModel : NSObject {
    
    
    
    func fetchCharacters() {
        
        NetworkManager.shared.execute(.listCharactersRequest, type: RMGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print(String(describing: model))
            case .failure(let error):
                print(String(describing: error))
            }
        }

    }
}



// MARK: RMCharacterViewController de kullanmak uzere collectionView icin extension olusturduk
extension CharacterListViewModel : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
    //cell boyutunu ayarladigimiz method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30)/2
        return CGSize(width: width, height: width * 1.5)
    }
}
