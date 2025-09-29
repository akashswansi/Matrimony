//
//  MatrimonyProfilesViewModel.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import Foundation
import Combine

final class MatrimonyProfilesViewModel: ObservableObject {
  @Published var profiles: [MatrimonyProfileData] = []
  @Published var errorMessage: String?
  @Published var isLoading = false

  private let repository: MatrimonyRepositoryProtocol?
  private var cancellables = Set<AnyCancellable>()
  private var currentPage = 1
  private let resultsPerPage: Int

  init(repository: MatrimonyRepositoryProtocol? = MatrimonyRepository(), resultsPerPage: Int = 10) {
    self.repository = repository
    self.resultsPerPage = resultsPerPage
    loadCached()
    fetchNextPage()
  }

  private func loadCached() {
    Task { @MainActor in
      profiles = repository?.getCachedProfiles() ?? []
    }
  }

  func fetchNextPage() {
    guard !isLoading else {
      return
    }
    isLoading = true
    repository?.fetchPagePublisher(page: currentPage, results: resultsPerPage)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        self?.isLoading = false
        if case .failure(let error) = completion {
          self?.errorMessage = error.localizedDescription
        }
      } receiveValue: { [weak self] newProfiles in
        self?.profiles = newProfiles
        self?.currentPage += 1
      }
      .store(in: &cancellables)
  }

  @MainActor
  func accept(_ profile: MatrimonyProfileData) {
    repository?.updateProfileStatus(profileID: profile.id, status: .accepted)
    updateLocalStatus(profile.id, status: .accepted)
  }

  @MainActor
  func decline(_ profile: MatrimonyProfileData) {
    repository?.updateProfileStatus(profileID: profile.id, status: .declined)
    updateLocalStatus(profile.id, status: .declined)
  }

  @MainActor
  private func updateLocalStatus(_ id: String, status: MatrimonyProfileStatus) {
    if let index = profiles.firstIndex(where: { $0.id == id }) {
      profiles[index].status = status
    }
  }
}
