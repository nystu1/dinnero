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

        let request = URLRequest(url: informationPage.url)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.load(request)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

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
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        decisionHandler(.allow)
    }
}
