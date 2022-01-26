import UIKit


protocol RandomDinnerInteractorOutput {
    func dinnerSuggestionsFetched(dinners: [RealmDinner])
}

class RandomDinnerInteractor: RandomDinnerViewControllerOutput {
    var output: RandomDinnerInteractorOutput?
    var firebaseService: FirebaseService?
    
    var dinners: [RealmDinner] = []
    
    init(output: RandomDinnerInteractorOutput, firebaseService: FirebaseService) {
        self.output = output
        self.firebaseService = firebaseService
    }
    
    func fetchDinnerSuggestions() {
        if dinners.isEmpty {
            firebaseService?.fetchDinnerSuggestions(completion: { dinners in
                self.output?.dinnerSuggestionsFetched(dinners: dinners)
            })
        }
    }
}
