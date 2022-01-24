import Foundation
import UIKit

extension UIViewController {
    func setCustomNavigationBar(_ titleText: String) {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        title.textAlignment = .center
        title.text = titleText
        title.textColor = .white
        navigationItem.titleView = title
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
