import UIKit

@IBDesignable
class DinnerTextField: UITextField {
    
    func setupView() {
        placeholderColor = .gray
        backgroundColor = .twitterDark1
        textColor = .white
        addDoneButtonOnKeyboard()
        autocorrectionType = .no
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    var placeholderColor: UIColor = .lightGray {
        didSet {
            self.setPlaceholderColor()
        }
    }
    
    private func setPlaceholderColor() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Ferdig", style: .done, target: self, action: #selector(doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(_: Any) {
        resignFirstResponder()
    }
    
}
