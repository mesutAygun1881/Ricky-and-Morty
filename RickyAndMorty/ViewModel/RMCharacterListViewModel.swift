//
//  CharacterListViewModel.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 3.01.2023.
//

import UIKit

protocol RMCharacterListViewModelDelegate : AnyObject{
    //collection view reload data
    func didLoadInitialCharacters()
    
    //secilen karakteri almak icin
    func didSelectCharacter(_ character : RMCharacter)
}
class RMCharacterListViewModel : NSObject {
    
    
    // MARK: PROPERTIES
    
    public weak var delegate : RMCharacterListViewModelDelegate?
    
    /// fetch character ile cekilen result arrayi ni cellViewModels icerisine ekliyoruz
    private var cellViewModels : [RMCharacterCollectionCellViewModel] = []
    private var characters : [RMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionCellViewModel(
                    characterName: character.name,
                    characterStatus: RMCharacterStatus(rawValue: character.status) ?? RMCharacterStatus.alive,
                    characterImage: URL(string: character.image))
                cellViewModels.append(viewModel)
                print(cellViewModels)
            }
        }
    }
    
    func fetchCharacters() {
        
        NetworkManager.shared.execute(.listCharactersRequest, type: RMGetAllCharactersResponse.self) {[weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self?.characters = results
                
                //collectionView reload data
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }

    }
}



// MARK: RMCharacterViewController de kullanmak uzere collectionView icin extension olusturduk
extension RMCharacterListViewModel : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterListCollectionViewCell.identifier, for: indexPath) as? RMCharacterListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    //cell boyutunu ayarladigimiz method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30)/2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let characterIndex = characters[indexPath.row]
        delegate?.didSelectCharacter(characterIndex)
    }
    
}
