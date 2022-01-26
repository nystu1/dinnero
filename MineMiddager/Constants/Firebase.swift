import Foundation

enum FirebaseConstants {
    static func dinnerSuggestionsCollection() -> String {
        guard let deviceLanguage = Locale.current.languageCode else {
            return "dinnerSuggestions_en"
        }
        switch deviceLanguage {
        case "nb":
            return "dinnersSuggestions"
        case "sv", "da":
            return "dinnerSuggestions_\(deviceLanguage)"
        default:
            return "dinnerSuggestions_en"
        }
    }
}
