//
//  DetailsViewController.swift
//  FRG
//
//  Created by Shanezzar Sharon on 16/06/2022.
//

import AsyncDisplayKit
import MarkdownKit

class DetailsViewController: ASDKViewController<ASScrollNode> {
    private let rootNode: ASScrollNode = {
        let node = ASScrollNode()
        node.automaticallyManagesSubnodes = true
        node.backgroundColor = .white
        node.automaticallyManagesContentSize = true
        node.scrollableDirections = [.up, .down]
        return node
    }()
    
    fileprivate let backNode: ASButtonNode = {
        let node = ASButtonNode()
        node.automaticallyManagesSubnodes = true
        node.setImage(UIImage(systemName: "arrowshape.turn.up.backward"), for: .normal)
        node.style.preferredSize = .init(width: 40, height: 40)
        return node
    }()
    
    fileprivate let userImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.automaticallyManagesSubnodes = true
        node.style.preferredSize = .init(width: 40, height: 40)
        node.contentMode = .scaleAspectFill
        return node
    }()
    
    fileprivate let fullNameNode = ASTextNode()
    fileprivate let languageNode = ASTextNode()
    fileprivate let starNode = ASTextNode()
    fileprivate let descriptionNode = ASTextNode()
    
    private let dividerNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .lightGray
        node.style.width = .init(unit: .fraction, value: 1)
        node.style.height = ASDimension(unit: .points, value: 1)
        return node
    }()
    
    private let readmeNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        return node
    }()
    
    private let repository: Repository
    private let markdownParser = MarkdownParser()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.rootNode.didEnterVisibleState()
    }
    
    init(repository: Repository) {
        self.repository = repository
        
        super.init(node: rootNode)
        
        backNode.addTarget(self, action: #selector(backAction), forControlEvents: .touchUpInside)
        
        userImageNode.url = URL(string: repository.owner.avatarUrl ?? "")
        fullNameNode.attributedText = NSAttributedString.attributedString(string: repository.fullName, fontSize: 16, color: .black)
        
        languageNode.attributedText = makeTitleText("Language", "\(repository.language ?? "N/A")")
        starNode.attributedText = makeTitleText("Star(s)", "⭐ \(repository.stargazersCount)")
        descriptionNode.attributedText = makeTitleText("Description", "\(repository.description ?? "N/A")")
        
        if let url = URL(string: repository.readme ?? "") {
            if let data = try? Data(contentsOf: url) {
                readmeNode.attributedText = markdownParser.parse(String(decoding: data, as: UTF8.self))
            }
        }
        
        rootNode.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else { return .init() }
            let userStack = ASStackLayoutSpec(direction: .horizontal, spacing: 16, justifyContent: .start, alignItems: .center, children: [
                self.userImageNode,
                self.fullNameNode
            ])
            
            let languageStarStack = ASStackLayoutSpec(direction: .horizontal, spacing: 16, justifyContent: .spaceBetween, alignItems: .center, children: [
                self.languageNode,
                self.starNode
            ])
            
            let finalStack = ASStackLayoutSpec(direction: .vertical, spacing: 16, justifyContent: .start, alignItems: .start, children: [
                self.backNode,
                userStack,
                languageStarStack,
                self.descriptionNode,
                self.dividerNode,
                self.readmeNode
            ])
            
            return ASInsetLayoutSpec(insets: .init(top: 16, left: 16, bottom: 16, right: 16), child: finalStack)
        }
    }
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func makeTitleText(_ title: String, _ text: String) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString()
        
        let titleAttributedString = NSAttributedString.attributedString(string: "\(title): ", fontSize: 13, color: .black)!
        let textAttributedString = NSAttributedString.attributedString(string: text, fontSize: 13, color: .lightGray)!
        
        mutableAttributedString.append(titleAttributedString)
        mutableAttributedString.append(textAttributedString)
        
        return mutableAttributedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
