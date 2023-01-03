//
//  Extensions.swift
//  RickyAndMorty
//
//  Created by Mesut Aygün on 3.01.2023.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views : UIView...){
        views.forEach ({
            addSubview($0)
        })
    }
}
