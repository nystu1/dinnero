import Foundation
import UIKit
import RealmSwift

protocol RandomDinnerViewControllerDelegate {
    func openDinnerUrl(dinner: RealmDinner)
}

protocol RandomDinnerViewControllerOutput {
    func fetchDinnerSuggestions()
}

class RandomDinnerViewController: UIViewController {
    @IBOutlet weak var randomDinnerLabel: UILabel!
    @IBOutlet weak var fromListButton: UIButton!
    @IBOutlet weak var fromUsButton: UIButton!
    
    var delegate: RandomDinnerViewControllerDelegate?
    var output: RandomDinnerViewControllerOutput?

    var dinners: [RealmDinner] = []
    var dinnerSuggestions: [RealmDinner] = []
    var currentDinner: RealmDinner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.fetchDinnerSuggestions()
        setTexts()
        view.backgroundColor = .twitterBackground
    }
    
    func setTexts (){
        randomDinnerLabel.text = "dinner_suggestion".localized()
        fromListButton.setTitle("dinner_suggestion_from_list".localized(), for: .normal)
        fromUsButton.setTitle("dinner_suggestion_from_us".localized(), for: .normal)
    }
    @IBAction func fromListTapped(_ sender: Any) {
        currentDinner = dinners.randomElement()
        randomDinnerLabel.text = currentDinner?.name
    }
    
    
    @IBAction func fromUsTapped(_ sender: Any) {
        currentDinner = dinnerSuggestions.randomElement()
        randomDinnerLabel.text = currentDinner?.name
    }

    @IBAction func dinnerLabelTapped(_ sender: Any) {
        guard let currentDinner = currentDinner else { return }
        dismiss(animated: true) {
            self.delegate?.openDinnerUrl(dinner: currentDinner)
        }
    }
}

extension RandomDinnerViewController: RandomDinnerPresenterOutput {
    func dinnerSuggestionsFetched(dinners: [RealmDinner]) {
        self.dinnerSuggestions = dinners
    }

}
