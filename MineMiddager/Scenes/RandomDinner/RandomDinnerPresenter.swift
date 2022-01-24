import UIKit
import Firebase

protocol RandomDinnerPresenterOutput {
    func dinnerSuggestionsFetched(dinners: [RealmDinner])
}

class RandomDinnerPresenter: RandomDinnerInteractorOutput {
    var output: RandomDinnerPresenterOutput?
    
    init(output: RandomDinnerPresenterOutput) {
        self.output = output
    }
    
    func dinnerSuggestionsFetched(dinners: [RealmDinner]) {
        output?.dinnerSuggestionsFetched(dinners: dinners)
    }
}
