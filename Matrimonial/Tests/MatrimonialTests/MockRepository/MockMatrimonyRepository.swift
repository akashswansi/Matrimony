//
//  MockMatrimonyRepository.swift
//  MatrimonialTests
//
//  Created by Akash Kumar on 29/09/25.
//
import Foundation
import Combine
@testable import Matrimonial

final class MockMatrimonyRepository: MatrimonyRepositoryProtocol {
    var cachedProfiles: [MatrimonyProfileData] = []
    var fetchedPages: [[MatrimonyProfileData]] = []
    var updateCalls: [(id: String, status: MatrimonyProfileStatus)] = []
    var shouldFailFetch = false

    func getCachedProfiles() -> [MatrimonyProfileData] {
        return cachedProfiles
    }

    func fetchPagePublisher(page: Int, results: Int) -> AnyPublisher<[MatrimonyProfileData], Error> {
        if shouldFailFetch {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        } else {
            let index = page - 1
            let profiles = index < fetchedPages.count ? fetchedPages[index] : []
            return Just(profiles)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }

    func updateProfileStatus(profileID: String, status: MatrimonyProfileStatus) {
        updateCalls.append((profileID, status))
    }
}
