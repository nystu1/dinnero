import UIKit

protocol NewDinnerViewControllerDelegate {
    func newDinnerAdded(name: String, url: String?)
}

class NewDinnerViewController: UIViewController {
    @IBOutlet weak var dinnerNameTextField: DinnerTextField!
    @IBOutlet weak var dinnerUrlTextField: DinnerTextField!
    @IBOutlet weak var submitButton: UIButton!
        
    var delegate: NewDinnerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setTexts()
        view.backgroundColor = .twitterBackground
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setTexts(){
        dinnerNameTextField.placeholder = "dinner_name_field_placeholder".localized()
        dinnerUrlTextField.placeholder = "dinner_link_field_placeholder".localized()
        submitButton.setTitle("add_dinner".localized(), for: .normal)
    }

    @IBAction func addDinnerTapped(_ sender: Any) {
        guard let dinnerName = dinnerNameTextField.text, !dinnerName.isEmpty else { return }
        if let urlString = dinnerUrlTextField.text,
            let url = URL(string:urlString),
           UIApplication.shared.canOpenURL(url) {
            delegate?.newDinnerAdded(name: dinnerName, url: urlString)
        } else {
            delegate?.newDinnerAdded(name: dinnerName, url: "")
        }
        dismiss(animated: true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
