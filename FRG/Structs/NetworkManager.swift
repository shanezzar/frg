//
//  NetworkManager.swift
//  FRG
//
//  Created by Shanezzar Sharon on 16/06/2022.
//

import Network

struct NetworkManager {
    static var isNetworkAvailable: Bool {
        NetworkMonitor.shared.isConnected
    }
    
}
