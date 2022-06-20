//
//  ListViewModel.swift
//  FRG
//
//  Created by Shanezzar Sharon on 18/06/2022.
//

import Foundation
import Combine

class ListViewModel {
    static let shared = ListViewModel()
    
    var displayData = [Repository]()
    var delegate: ListViewModelDelegate?
    
    var accessToken: String = ""
    var page = 1
    
    private var repositoryService: RepositoryServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private var searchCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    init(repositoryService: RepositoryServiceProtocol = RepositoryService()) {
        self.repositoryService = repositoryService
        _ = NetworkMonitor.shared
    }
    
    func fetchData(string: String) {
        self.delegate?.loading(true)
        repositoryService.searchRepository(accessToken, query: string, page: page)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.displayData = []
                    self.delegate?.loading(false)
                    self.delegate?.error(error.localizedDescription)
                case .finished:
                    self.delegate?.loading(false)
                    break
                }
            } receiveValue: { repo in
                print(self.page)
                self.page += 1
                self.displayData = self.displayData + repo.items
                self.delegate?.loading(false)
            }
            .store(in: &cancellables)
    }
    
}
