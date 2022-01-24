//
//  Firebase.swift
//  MineMiddager
//
//  Created by Ådne Nystuen on 24/01/2022.
//

import Foundation


enum FirebaseConstants {
    static func dinnerSuggestionsCollection() -> String {
        let deviceLanguage = Locale.current.languageCode
        switch deviceLanguage {
        case "nb":
            return "dinnersSuggestions"
        default:
            return "dinnerSuggestions_en"
        }
    }
}
