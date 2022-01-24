import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToDinnersTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DinnerList", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DinnerListViewController")
        navigationController?.pushViewController(vc, animated: false)
    }
    


}
