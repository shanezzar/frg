//
//  ListViewController.swift
//  FRG
//
//  Created by Shanezzar Sharon on 16/06/2022.
//

import AsyncDisplayKit

class ListViewController: ASDKViewController<ASDisplayNode> {
    private let rootNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.automaticallyManagesSubnodes = true
        node.backgroundColor = .white
        return node
    }()
    
    private let searchImageNode: ASImageNode = {
        let node = ASImageNode()
        node.image = UIImage(named: "logo")
        node.style.preferredSize = .init(width: 24, height: 24)
        node.contentMode = .scaleAspectFit
        return node
    }()
    
    let searchNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.attributedPlaceholderText = NSAttributedString.attributedString(string: "Search repo here...", fontSize: 18, color: .gray)
        node.tintColor = .black
        node.textView.font = .systemFont(ofSize: 18)
        node.style.width = .init(unit: .fraction, value: 0.7)
        return node
    }()
    
    private let dividerNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .lightGray
        node.style.width = .init(unit: .fraction, value: 1)
        node.style.height = ASDimension(unit: .points, value: 1)
        return node
    }()
    
    private let tableNode: ASTableNode = {
        let node = ASTableNode()
        node.automaticallyManagesSubnodes = true
        node.backgroundColor = .white
        node.style.width = .init(unit: .fraction, value: 1)
        node.style.height = ASDimensionMakeWithFraction(0.9)
        return node
    }()
    
    private let listViewModel = ListViewModel.shared
    
    public override init() {
        super.init(node: rootNode)
        rootNode.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else { return .init() }
            
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            self.searchNode.delegate = self
            
            self.tableNode.delegate = self
            self.tableNode.dataSource = self
            
            self.listViewModel.delegate = self
            
            self.addDoneToSearch()
            
            let searchStack = ASStackLayoutSpec(direction: .horizontal, spacing: 16, justifyContent: .start, alignItems: .center, children: [
                self.searchImageNode,
                self.searchNode
            ])
            
            let insetedSearchNode = ASInsetLayoutSpec(insets: .init(top: 60, left: 24, bottom: 16, right: 24), child: searchStack)
            
            return ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .stretch, children: [
                insetedSearchNode,
                self.dividerNode,
                self.tableNode
            ])
        }
    }
    
    private func addDoneToSearch() {
        let bar = UIToolbar()
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        bar.items = [flexButton, doneButton]
        bar.sizeToFit()
        searchNode.textView.inputAccessoryView = bar
    }
    
    @objc private func doneTapped() {
        view.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListViewController: ASEditableTextNodeDelegate {
    func editableTextNodeDidChangeSelection(_ editableTextNode: ASEditableTextNode, fromSelectedRange: NSRange, toSelectedRange: NSRange, dueToEditing: Bool) {
        if editableTextNode.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return }
        listViewModel.displayData = []
        listViewModel.page = 1
        listViewModel.fetchData(string: editableTextNode.textView.text)
    }
    
}

extension ListViewController: ListViewModelDelegate {
    func loading(_ isLoading: Bool) {
        if !isLoading {
            tableNode.reloadData()
        }
    }
    
    func error(_ message: String) {
        let alert = UIAlertController(title: "Ops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ListViewController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.displayData.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let repository = listViewModel.displayData[indexPath.row]
        return RepositoryCellNode(repository: repository)
    }
    
    func tableView(_ tableView: ASTableView, willDisplayNodeForRowAt indexPath: IndexPath) {
        if indexPath.row == listViewModel.displayData.count - 2 {
            listViewModel.fetchData(string: searchNode.textView.text)
        }
    }
    
}

extension ListViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let repository = listViewModel.displayData[indexPath.row]
        let details = DetailsViewController(repository: repository)
        self.navigationController?.pushViewController(details, animated: true)
    }
    
}
