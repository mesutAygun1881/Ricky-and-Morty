//
//  RMCharacterDetailViewController.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 4.01.2023.
//

import UIKit

class RMCharacterDetailViewController: UIViewController {
    
    private var viewModel : RMCharacterDetailViewModel
    
     init(viewModel : RMCharacterDetailViewModel) {
         self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view.
    }
    

 

}
