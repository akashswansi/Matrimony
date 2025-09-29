//
//  MatrimonyRepository.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import Foundation
import Combine
final class MatrimonyRepository: MatrimonyRepositoryProtocol {
  private let apiClient: MatrimonyAPIServiceProtocol
  private let localStorage: MatrimonyLocalDataSourceProtocol

  init(apiClient: MatrimonyAPIServiceProtocol = MatrimonyAPIService(),
       localStorage: MatrimonyLocalDataSourceProtocol = MatrimonyLocalDataSource()) {
    self.apiClient = apiClient
    self.localStorage = localStorage
  }

  func getCachedProfiles() -> [MatrimonyProfileData] {
    localStorage.fetchAll()
  }

  func fetchPagePublisher(page: Int, results: Int) -> AnyPublisher<[MatrimonyProfileData], Error> {
    Deferred {
      Future { promise in
        Task {
          do {
            let profiles = try await self.apiClient.fetchProfiles(page: page, results: results)
            self.localStorage.save(profiles: profiles)
            promise(.success(self.localStorage.fetchAll()))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func updateProfileStatus(profileID: String, status: MatrimonyProfileStatus) {
    localStorage.updateStatus(profileID: profileID, status: status)
  }
}
