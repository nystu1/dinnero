//
//  String+Extensions.swift
//  MineMiddager
//
//  Created by Ådne Nystuen on 24/01/2022.
//

import Foundation


extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
        value: self,
        comment: self)
    }
}
