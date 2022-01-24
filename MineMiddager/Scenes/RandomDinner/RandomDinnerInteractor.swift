import UIKit
import Firebase

protocol RandomDinnerInteractorOutput {
    func dinnerSuggestionsFetched(dinners: [RealmDinner])
}

class RandomDinnerInteractor: RandomDinnerViewControllerOutput {
    var output: RandomDinnerInteractorOutput?
    var database: Firestore?
    
    var dinners: [RealmDinner] = []
    
    init(output: RandomDinnerInteractorOutput, database: Firestore = Firestore.firestore()) {
        self.output = output
        self.database = database
    }
    
    func fetchDinnerSuggestions() {
        if dinners.isEmpty {
            database?.collection("dinnersSuggestions").getDocuments(completion: { [weak self] snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    return
                }
                do {
                    documents.forEach{ self?.dinners.append(RealmDinner(snapshot: $0)) }
                    guard let dinners = self?.dinners else { return }
                    self?.output?.dinnerSuggestionsFetched(dinners: dinners)

                } catch {
                    return
                }
            })
        }
    }
}
