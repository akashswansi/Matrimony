//
//  MatrimonyAPIServiceProtocol.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import Foundation
protocol MatrimonyAPIServiceProtocol {
    func fetchProfiles(page: Int, results: Int) async throws -> [MatrimonyProfileData]
}
