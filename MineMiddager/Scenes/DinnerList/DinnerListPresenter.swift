import Foundation
import RealmSwift

protocol DinnerListPresenterOutput {
    func updateDinnerTable(dinners: [RealmDinner])
}

class DinnerListPresenter: DinnerListInteractorOutput {
    var output: DinnerListPresenterOutput?

    init(output: DinnerListPresenterOutput) {
        self.output = output
    }
    
    func updateDinnerTable(dinners: [RealmDinner]) {
        DispatchQueue.main.async {
            self.output?.updateDinnerTable(dinners: dinners)
        }
    }
}
