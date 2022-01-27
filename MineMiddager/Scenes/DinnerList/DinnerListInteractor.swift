import Foundation
import RealmSwift

protocol DinnerListInteractorOutput {
    func updateDinnerTable(dinners: [RealmDinner])
}

class DinnerListInteractor: DinnerListViewControllerOutput {
    var output: DinnerListInteractorOutput?
    
    var dinners: [RealmDinner]
    
    
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    init(output: DinnerListInteractorOutput) {
        self.output = output
        dinners = []
    }
    
    func viewDidLoad() {
        dinners = Array(realm.objects(RealmDinner.self))
        
        if(!UserDefaults.standard.bool(forKey: Defaults.initialDinnerSuggestionsHasBeenAdded)){
            UserDefaults.standard.set(true, forKey: Defaults.initialDinnerSuggestionsHasBeenAdded)
            if dinners.isEmpty {
                dinners = getInitialDinnerSuggestions()
            }
        }
        
        output?.updateDinnerTable(dinners: dinners)
    }

    func newDinnerAdded(name: String, url: String?) {
        let dinner = RealmDinner()
        dinner.name = name
        dinner.url = url
        
        try! realm.write {
            realm.add(dinner)
            dinners.append(dinner)
        }
        
        output?.updateDinnerTable(dinners: dinners)
    }

    func removeDinner(at: Int) {
        try! realm.write {
            realm.delete(dinners[at])
            dinners.remove(at: at)
        }
        output?.updateDinnerTable(dinners: dinners)
    }
    
    private func getInitialDinnerSuggestions() -> [RealmDinner] {
        let initialDinners = [ "defaultDinnerSuggestionOne".localized(),"defaultDinnerSuggestionTwo".localized()]
        return initialDinners.map({
            RealmDinner(name: $0)
        })
    }
}
