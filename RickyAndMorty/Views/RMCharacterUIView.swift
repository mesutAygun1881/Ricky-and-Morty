//
//  CharacterListView.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 3.01.2023.
//

import UIKit

protocol RMCharacterUIViewDelegate : AnyObject {
    //bu protokol ile secilen karakteri ve ui view i aliyoruz
    func rmCharacterListView(_ characterListView : RMCharacterUIView , didSelectCharacter character : RMCharacter)
}

final class RMCharacterUIView: UIView {
    
    
    // MARK: PROPERTIES
    
    private let viewmodel = RMCharacterViewModel()
    public weak var delegate : RMCharacterUIViewDelegate?
    // MARK: UI ELEMENTS
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
        
    }()
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 15, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.identifier)
        ///for pagination RMFooterLoadingCollectionReusableView olusturuldu icerisinde spinner var registerdan sonra methodlarini  viewModel icerisinde collection funclari icinde yazdik
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
        
    }()
   
    
    
    // MARK: FUNCTIONS
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView(){
        addSubviews(spinner , collectionView)
        addConstraints()
        spinner.startAnimating()
        setUpCollectionView()
        viewmodel.delegate = self
        viewmodel.fetchCharacters()
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    
    //collectionView ciziliyor CharacterListViewModel icerisinde extensionda
    private func setUpCollectionView(){
        collectionView.dataSource = viewmodel
        collectionView.delegate = viewmodel
    }
}


// bu extension da RMCharacterListViewModel icerisindeki protokoller ile controllere veriyi ilettik
extension RMCharacterUIView : RMCharacterViewModelDelegate {
    
    // collection icinde didselectte delegate ile characteri aldik character controllere gondormek uzere veriyi tasidik
    func didSelectCharacter(_ character: RMCharacter) {
        self.delegate?.rmCharacterListView(self, didSelectCharacter: character)
    }
    
    func didLoadInitialCharacters() {
        collectionView.reloadData()
        self.spinner.stopAnimating()
        
        self.collectionView.isHidden = false
        
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreCharacter(with newIndexPaths : [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
}
