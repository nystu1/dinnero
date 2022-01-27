import UIKit
import RealmSwift
import SwipeCellKit

protocol DinnerListViewControllerOutput {
    func viewDidLoad()
    func newDinnerAdded(name: String, url: String?)
    func removeDinner(at: Int)
    func addUrlToDinner(at: Int, url: String)
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

extension DinnerListViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "delete".localized()) { action, indexPath in
            self.output?.removeDinner(at: indexPath.row)
        }
        
        let addUrlAction = SwipeAction(style: .default, title: "add_url".localized()) { action, indexPath in
            self.hideSwipe(at: indexPath.row)
            //Variable to store alertTextField
              var textField = UITextField()
              
            let alert = UIAlertController(title: "add_url".localized(), message: "", preferredStyle: .alert)
              alert.addTextField { alertTextField in
                  alertTextField.placeholder = "paste_url".localized()
                  textField = alertTextField
              }
              
            let addAction = UIAlertAction(title: "add".localized(), style: .default) { action in
                  if let text = textField.text {
                      self.output?.addUrlToDinner(at: indexPath.row, url: text)
                  }
              }
            
            let cancelAction = UIAlertAction(title: "cancel".localized(), style: .default) { action in
                if let text = textField.text {
                    self.hideSwipe(at: indexPath.row)
                    self.dismiss(animated: true)
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(addAction)

            self.present(alert, animated: true, completion: nil)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction, addUrlAction]
    }
    
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
        cell.delegate = self
        return cell
    }
}

extension DinnerListViewController: DinnerListPresenterOutput {
    func updateDinnerTable(dinners: [RealmDinner]) {
        self.dinners = dinners
        tableView.reloadData()
        
        if !UserDefaults.standard.bool(forKey: Defaults.hasSeenDeleteFunctionality) {
            if let cell = tableView.cellForRow(at: IndexPath(row: dinners.count - 1, section: 0)) as? SwipeTableViewCell {
                showSwipe(at: dinners.count - 1, delay: .now() + 1)
                UserDefaults.standard.set(true, forKey: Defaults.hasSeenDeleteFunctionality)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    cell.hideSwipe(animated: true)
                }
            }
        }
    }
    
    func showSwipe(at row: Int, delay: DispatchTime = .now()) {
        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SwipeTableViewCell {
            DispatchQueue.main.asyncAfter(deadline: delay) {
                cell.showSwipe(orientation: .right, animated: true)
            }
        }
    }
    
    func hideSwipe(at row: Int, delay: DispatchTime = .now()) {
        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SwipeTableViewCell {
            DispatchQueue.main.asyncAfter(deadline: delay) {
                cell.hideSwipe(animated: true)
            }
        }
    }

}
