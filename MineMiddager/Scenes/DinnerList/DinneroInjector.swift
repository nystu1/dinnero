import Foundation

enum DinneroInjector {
    static func inject(controller: DinnerListViewController) {
        let presenter = DinnerListPresenter(output: controller)
        let interactor = DinnerListInteractor(output: presenter)
        let router = DinnerListRouter(vc: controller)
        controller.output = interactor
        controller.router = router
    }
    
    static func inject(controller: RandomDinnerViewController, dinners: [RealmDinner]) {
        let presenter = RandomDinnerPresenter(output: controller)
        let interactor = RandomDinnerInteractor(output: presenter)
        controller.output = interactor
        controller.dinners = dinners
    }
}
