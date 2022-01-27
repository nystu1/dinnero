import UIKit
import SwipeCellKit

class DinnerListTableViewCell: SwipeTableViewCell {

    let identifier = "DinnerListTableViewCell"
    
    @IBOutlet weak var dinnerLabel: UILabel!
    @IBOutlet weak var linkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(dinner: RealmDinner) {
        self.dinnerLabel.text = dinner.name
        self.dinnerLabel.textColor = .white
        if let urlString = dinner.url,
           let url = URL(string: urlString),
           UIApplication.shared.canOpenURL(url) {
            linkImageView.isHidden = false
            linkImageView.image = UIImage(named: "externalLink")?.withTintColor(.gray)
        } else {
            linkImageView.isHidden = true
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .twitterDark1
        selectedBackgroundView = bgColorView
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
