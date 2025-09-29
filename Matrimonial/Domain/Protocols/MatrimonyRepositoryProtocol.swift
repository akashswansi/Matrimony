//
//  MatrimonyRepositoryProtocol.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import Foundation
import Combine

protocol MatrimonyRepositoryProtocol {
    func getCachedProfiles() -> [MatrimonyProfileData]
    func fetchPagePublisher(page: Int, results: Int) -> AnyPublisher<[MatrimonyProfileData], Error>
    func updateProfileStatus(profileID: String, status: MatrimonyProfileStatus)
}
