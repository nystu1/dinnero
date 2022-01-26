import UIKit
import RealmSwift

protocol DinnerListViewControllerOutput {
    func viewDidLoad()
    func newDinnerAdded(name: String, url: String?)
    func removeDinner(at: Int)
}

class DinnerListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewDinnerButton: UIButton!
    @IBOutlet weak var randomDinner: UIButton!

    var output: DinnerListViewControllerOutput?
    var router: DinnerListRouter?
    
    var dinners: [RealmDinner] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        DinneroInjector.inject(controller: self)
        output?.viewDidLoad()
        setTexts()
        setCustomNavigationBar("dinnero")
        view.backgroundColor = .twitterBackground
        addNewDinnerButton.tintColor = .twitterLightGray
        randomDinner.tintColor = .twitterLightGray
        tableView.register(UINib(nibName: "DinnerListTableViewCell", bundle: .main), forCellReuseIdentifier: "DinnerListTableViewCell")
    }
    
    func setTexts() {
        addNewDinnerButton.setTitle("new_dinner".localized(), for: .normal)
        randomDinner.setTitle("dinner_suggestion".localized(), for: .normal)
    }
    
    @IBAction func randomDinnerTapped(_ sender: Any) {
        router?.showRandomDinnerPane(dinners: dinners)
    }
    
    @IBAction func newDinnerTapped(_ sender: Any) {
        router?.showNewDinnerPane()
    }
    

}
extension DinnerListViewController: NewDinnerViewControllerDelegate, RandomDinnerViewControllerDelegate {
    func openDinnerUrl(dinner: RealmDinner) {
        openDinnerReceipe(dinner: dinner)
    }
    
    func newDinnerAdded(name: String, url: String?) {
        output?.newDinnerAdded(name: name, url: url)
    }
    
    func openDinnerReceipe(dinner: RealmDinner){
        router?.openDinnerReceipe(dinner: dinner)
    }
}

extension DinnerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDinnerUrl(dinner: dinners[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dinners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DinnerListTableViewCell", for: indexPath) as! DinnerListTableViewCell
        cell.configure(dinner: dinners[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            output?.removeDinner(at: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension DinnerListViewController: DinnerListPresenterOutput {
    func updateDinnerTable(dinners: [RealmDinner]) {
        self.dinners = dinners
        tableView.reloadData()
    }

}
