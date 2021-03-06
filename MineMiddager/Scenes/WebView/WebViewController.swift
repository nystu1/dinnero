import Foundation
import UIKit
import WebKit

class InformationPage {
    var title: String
    var url: URL

    init(title: String, url: URL) {
        self.title = title
        self.url = url
    }
}

class WebViewController: UIViewController {
    // Set by InformationRouter before showing
    var informationPage: InformationPage!

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBackground
        navigationItem.title = informationPage.title
        setupCopyUrlButton()

        let request = URLRequest(url: informationPage.url)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.load(request)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

    }
    
    private func setupCopyUrlButton() {
        if let copyImage = UIImage(named: "copy_icon.png") {
            let cancelButton = UIBarButtonItem(image: copyImage.resize(to: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(copyUrlTapped(sender:)))
            cancelButton.tintColor = .white
            cancelButton.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem = cancelButton
            }
        }
    }
    
    private func setupUrlHasBeenCopiedLabel() {
        let urlHasBeenCopiedButton = UIBarButtonItem(title: "url_copied".localized(), style: .plain, target: self, action: nil)
        urlHasBeenCopiedButton.tintColor = .white
        urlHasBeenCopiedButton.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        navigationItem.rightBarButtonItem = urlHasBeenCopiedButton
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.setupCopyUrlButton()
        }
    }
    
    @objc func copyUrlTapped(sender _: UIBarButtonItem) {
        UIPasteboard.general.string = webView.url?.absoluteString
        setupUrlHasBeenCopiedLabel()
    }
    
    @IBAction func rightSwiped(_ sender: Any) {
        webView.goBack()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = !webView.canGoBack

    }
    @IBAction func leftSwiped(_ sender: Any) {
        webView.goForward()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = !webView.canGoBack
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            guard let url = navigationAction.request.url else {return}
            webView.load(URLRequest(url: url))
            setupCopyUrlButton()
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        decisionHandler(.allow)
    }
}
