//
//  AuthViewController.swift
//  FRG
//
//  Created by Shanezzar Sharon on 14/06/2022.
//

import AsyncDisplayKit
import WebKit

class AuthViewController: ASDKViewController<ASDisplayNode> {
    private let rootNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.automaticallyManagesSubnodes = true
        node.backgroundColor = .white
        return node
    }()
    
    private let imageNode: ASImageNode = {
        let node = ASImageNode()
        node.image = UIImage(named: "logo")
        return node
    }()
    
    private let loginNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setTitle("Login with Github", with: nil, with: .white, for: .normal)
        node.style.width = ASDimension(unit: .fraction, value: 0.6)
        node.style.height = ASDimension(unit: .points, value: 50)
        node.backgroundColor = .black
        node.cornerRadius = 25
        return node
    }()
    
    override init() {
        super.init(node: rootNode)
        rootNode.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else { return .init() }
            self.loginNode.addTarget(self, action: #selector(self.loginPressed), forControlEvents: .touchUpInside)
            return ASStackLayoutSpec(direction: .vertical, spacing: 24, justifyContent: .center, alignItems: .center, children: [
                self.imageNode,
                self.loginNode
            ])
        }
    }
    
    @objc func loginPressed() {
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        let githubVC = ASDKViewController()
        githubVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: githubVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: githubVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: githubVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: githubVC.view.trailingAnchor)
        ])

        let authURLFull = "https://github.com/login/oauth/authorize?client_id=" + Constants.CLIENT_ID + "&scope=" + Constants.SCOPE + "&redirect_uri=" + Constants.REDIRECT_URI + "&state=" + UUID().uuidString
        let urlRequest = URLRequest(url: URL(string: authURLFull)!)
        webView.load(urlRequest)

        // Create Navigation Controller
        let navController = ASDKNavigationController(rootViewController: githubVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        githubVC.navigationItem.leftBarButtonItem = cancelButton
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical

        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.requestForCallbackURL(request: navigationAction.request)
        decisionHandler(.allow)
    }

    func requestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(Constants.REDIRECT_URI) {
            if requestURLString.contains("code=") {
                if let range = requestURLString.range(of: "=") {
                    let githubCode = requestURLString[range.upperBound...]
                    if let range = githubCode.range(of: "&state=") {
                        let githubCodeFinal = githubCode[..<range.lowerBound]
                        githubRequestForAccessToken(authCode: String(githubCodeFinal))

                        // Close GitHub Auth ViewController after getting Authorization Code
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }

    func githubRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&client_id=" + Constants.CLIENT_ID + "&client_secret=" + Constants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: Constants.TOKEN_URL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, _) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                let accessToken = results?["access_token"] as! String
                ListViewModel.shared.accessToken = accessToken
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(ListViewController(), animated: true)
                }
            }
        }
        task.resume()
    }
}
