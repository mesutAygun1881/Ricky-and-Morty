//
//  ViewController.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 3.01.2023.
//

import UIKit

class RMMainTabBarController: UITabBarController {
    
    // MARK: UI ELEMENTS

    // MARK: PROPERTIES
    
    
    // MARK: FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //tabbar function
        setupTabBar()
    }
     
    // MARK: TAB BAR FUNCTION
    func setupTabBar(){
        let vc1 = UINavigationController(rootViewController: RMCharacterViewController())
        let vc2 = UINavigationController(rootViewController: RMLocationViewController())
        let vc3 = UINavigationController(rootViewController: RMEpisodeViewController())
        let vc4 = UINavigationController(rootViewController: RMSettingsViewController())
        
        vc1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person"), tag: 1)
        vc2.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "globe"), tag: 2)
        vc3.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv"), tag: 3)
        vc4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        vc1.navigationItem.largeTitleDisplayMode = .automatic
        vc2.navigationItem.largeTitleDisplayMode = .automatic
        vc3.navigationItem.largeTitleDisplayMode = .automatic
        vc4.navigationItem.largeTitleDisplayMode = .automatic
        
        for nav in [vc1 , vc2 , vc3 , vc4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([vc1 , vc2 , vc3 , vc4], animated: true)
    }

}

