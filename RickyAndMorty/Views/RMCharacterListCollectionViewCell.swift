//
//  RMCharacterListCollectionViewCell.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 4.01.2023.
//

import UIKit

class RMCharacterListCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: PROPERTIES
    static let identifier = "RMCharacterListCollectionViewCell"
    
    
    // MARK: UI ELEMENTS
    
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    private let nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .label
        nameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
        
    }()
    
    
    private let statusLabel : UILabel = {
        let statusLabel = UILabel()
        statusLabel.textColor = .label
        statusLabel.font = .systemFont(ofSize: 16, weight: .regular)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        return statusLabel
        
    }()
    
    // MARK: FUNCTIONS
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(imageView , nameLabel , statusLabel)
        addConstraints()
        setUpLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// prepareForReuse hucre icini resetler
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
    
    // dark mode yada light mode a gectiginde setuplayer tekrar calisir
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setUpLayer()
    }
    
    func setUpLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.cornerRadius = 4
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor ,constant: 3),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor , constant: -5),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor , constant: -2),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 4),
            
            statusLabel.heightAnchor.constraint(equalToConstant: 40),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 4),
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        
        ])
       
    }
    
    public func configure(with viewModel : RMCharacterCollectionCellViewModel){
        self.nameLabel.text = viewModel.characterName
        self.statusLabel.text = viewModel.characterStatusText
        viewModel.fetchImage {[weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(error)
                break
            }
        }
       
    }
    
}
