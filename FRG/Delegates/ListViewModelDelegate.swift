//
//  ListViewModelDelegate.swift
//  FRG
//
//  Created by Shanezzar Sharon on 19/06/2022.
//

protocol ListViewModelDelegate: AnyObject {
    func loading(_ is: Bool)
    func error(_ message: String)
}
