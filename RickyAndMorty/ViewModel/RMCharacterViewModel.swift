//
//  CharacterListViewModel.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 3.01.2023.
//

import UIKit

//bu protokol collection view icerisinde reload data yapmak ve didselect te secilen karakteri almak icin kullanilir
protocol RMCharacterViewModelDelegate : AnyObject{
    //collection view reload data
    func didLoadInitialCharacters()
    
    //secilen karakteri almak icin
    func didSelectCharacter(_ character : RMCharacter)
    
    
    //pagination icin count
    func didLoadMoreCharacter(with newIndexPaths : [IndexPath])
}
class RMCharacterViewModel : NSObject {
    
    
    // MARK: PROPERTIES
    
    public weak var delegate : RMCharacterViewModelDelegate?
    
    /// fetch character ile cekilen result arrayi ni cellViewModels icerisine ekliyoruz
    private var cellViewModels : [RMCharacterCollectionCellViewModel] = []
    
    private var isLoadingMoreCharacters = false
    
    private var apiInfo : RMGetAllCharactersResponse.Info? = nil
    private var characters : [RMCharacter] = [] {
        didSet {
            //pagination yaparken ayni karakter isimli varsa alma
            for character in characters {
                let viewModel = RMCharacterCollectionCellViewModel(
                    characterName: character.name,
                    characterStatus: RMCharacterStatus(rawValue: character.status) ?? RMCharacterStatus.alive,
                    characterImage: URL(string: character.image))
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
                print(cellViewModels)
            }
        }
    }
    
    
    
    // MARK: FUNCTIONS
    
    /// fetch 20 characters
    func fetchCharacters() {
        
        NetworkManager.shared.execute(.listCharactersRequest, type: RMGetAllCharactersResponse.self) {[weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.characters = results
                self?.apiInfo = info
                //collectionView reload data
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }

    }
    
    /// Paginate if additional characters
     func fetchAdditionalCharacters(url : URL){
        guard !isLoadingMoreCharacters else {
            return
        }
       
            
           isLoadingMoreCharacters = true
        
        
        guard let request = NetworkHelper(url: url) else {
            isLoadingMoreCharacters = false
            return
        }
        
        NetworkManager.shared.execute(request, type: RMGetAllCharactersResponse.self) {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
          
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                let originalCount = strongSelf.characters.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startingIndex = total - newCount - 1
                let indexPathToAdd : [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap ({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.characters.append(contentsOf: moreResults)
                
               /// collectionView reload data
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacter(with: indexPathToAdd)
                    
                }
                strongSelf.isLoadingMoreCharacters = false
                
            case .failure(let error):
                print(error)
                self?.isLoadingMoreCharacters = false
            }
        }
    }
    public var shouldShowLoadMoreIndicator : Bool {
        return apiInfo?.next != nil
    }
   
}



// MARK: RMCharacterViewController de kullanmak uzere collectionView icin extension olusturduk
extension RMCharacterViewModel : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.identifier, for: indexPath) as? RMCharacterCollectionViewCell else {
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
        
          // secilen karakteri protokolle aldik
        delegate?.didSelectCharacter(characterIndex)
    }
    
    // for pagination  viewForSupplementaryElementOfKind
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
             fatalError("error")
        }
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("unspoorted")
        }
       
        
        if self.isLoadingMoreCharacters {
            footer.startAnimating()
        }
        return footer
    }
    // for pagination  referenceSizeForFooterInSection
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
}


// MARK: ScrollView Delegate for Paginate


extension RMCharacterViewModel : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator ,
              !isLoadingMoreCharacters ,
              !cellViewModels.isEmpty ,
        let nextUrlString = apiInfo?.next ,
        let url = URL(string: nextUrlString) else {
            return
        }
        
    
      
            
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
               
                self.fetchAdditionalCharacters(url : url)
            }
      
        
    }
}

