import UIKit

class DinnerListRouter {
    var vc: DinnerListViewController?
    
    init(vc: DinnerListViewController) {
        self.vc = vc
    }
    
    func showNewDinnerPane() {
        let storyboard = UIStoryboard(name: "DinnerList", bundle: nil)
        let newDinnerVc = storyboard.instantiateViewController(withIdentifier: "NewDinnerViewController") as! NewDinnerViewController
        newDinnerVc.delegate = vc
        if let presentationController = newDinnerVc.presentationController as? UISheetPresentationController {
             presentationController.detents = [.medium()]
         }
        vc?.present(newDinnerVc, animated: true)
    }
    
    func showRandomDinnerPane(dinners: [RealmDinner]) {
        let storyboard = UIStoryboard(name: "DinnerList", bundle: nil)
        let randomDinnerVc = storyboard.instantiateViewController(withIdentifier: "RandomDinnerViewController") as! RandomDinnerViewController
        randomDinnerVc.delegate = vc
        DinneroInjector.inject(controller: randomDinnerVc, dinners: dinners)
        if let presentationController = randomDinnerVc.presentationController as? UISheetPresentationController {
             presentationController.detents = [.medium()]
         }
        vc?.present(randomDinnerVc, animated: true)
    }
    
    func openDinnerReceipe(dinner: RealmDinner) {
        guard let name = dinner.name else { return }
        
        var receiptUrl: URL?
        if let urlString = dinner.url,
           let url = URL(string:urlString),
           UIApplication.shared.canOpenURL(url) {
            receiptUrl = url
        }
        else {
            receiptUrl = Links.googleSearch(dinner: name)
        }
        
        let storyboard = UIStoryboard(name: "DinnerList", bundle: nil)
        let webViewVc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webViewVc.informationPage = InformationPage(title: name, url: receiptUrl!)
        vc?.navigationController?.pushViewController(webViewVc, animated: true)
    }

    
}
