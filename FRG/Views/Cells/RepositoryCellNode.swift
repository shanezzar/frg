//
//  RepositoryCellNode.swift
//  FRG
//
//  Created by Shanezzar Sharon on 18/06/2022.
//

import AsyncDisplayKit

class RepositoryCellNode: ASCellNode {
    let repository: Repository
    
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
    
    init(repository: Repository) {
        self.repository = repository
        
        super.init()
        self.automaticallyManagesSubnodes = true
        
        userImageNode.url = URL(string: repository.owner.avatarUrl ?? "")
        fullNameNode.attributedText = NSAttributedString.attributedString(string: repository.fullName, fontSize: 16, color: .black)
        
        languageNode.attributedText = makeTitleText("Language", "\(repository.language ?? "N/A")")
        starNode.attributedText = makeTitleText("Star(s)", "⭐ \(repository.stargazersCount)")
        descriptionNode.attributedText = makeTitleText("Description", "\(repository.description ?? "N/A")")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let userStack = ASStackLayoutSpec(direction: .horizontal, spacing: 16, justifyContent: .start, alignItems: .center, children: [
            self.userImageNode,
            self.fullNameNode
        ])
        
        let languageStarStack = ASStackLayoutSpec(direction: .horizontal, spacing: 16, justifyContent: .spaceBetween, alignItems: .stretch, children: [
            self.languageNode,
            self.starNode
        ])
        
        let finalStack = ASStackLayoutSpec(direction: .vertical, spacing: 16, justifyContent: .center, alignItems: .stretch, children: [
            userStack,
            languageStarStack,
            self.descriptionNode
        ])
        
        return ASInsetLayoutSpec(insets: .init(top: 16, left: 16, bottom: 16, right: 16), child: finalStack)
    }
    
    private func makeTitleText(_ title: String, _ text: String) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString()
        
        let titleAttributedString = NSAttributedString.attributedString(string: "\(title): ", fontSize: 13, color: .black)!
        let textAttributedString = NSAttributedString.attributedString(string: text, fontSize: 13, color: .lightGray)!
        
        mutableAttributedString.append(titleAttributedString)
        mutableAttributedString.append(textAttributedString)
        
        return mutableAttributedString
    }
    
}
