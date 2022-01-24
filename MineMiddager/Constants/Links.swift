import Foundation
import UIKit

enum Links {
    static func googleSearch(dinner: String?) -> URL? {
        guard var dinner = dinner else { return nil }
        dinner = dinner.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        return URL(string: "https://google.gprivate.com/search.php?search?q=\(dinner)+\("recipe".localized())")
    }
}
