//
//  MatrimonyAPIService.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import Foundation


final class MatrimonyAPIService: MatrimonyAPIServiceProtocol {

  func fetchProfiles(page: Int, results: Int) async throws -> [MatrimonyProfileData] {
    let request = try MatrimonyAPIRequest.profiles(page: page, results: results).buildURLRequest()

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let http = response as? HTTPURLResponse,
          (200..<300).contains(http.statusCode) else {
      throw URLError(.badServerResponse)
    }

    let decoded = try JSONDecoder().decode(UserProfileData.self, from: data)

    return decoded.results.map {
      MatrimonyProfileData(
        id: $0.login.uuid,
        name: "\($0.name.title) \($0.name.first) \($0.name.last)",
        age: $0.dob.age,
        location: "\($0.location.city), \($0.location.state)",
        imageUrl: $0.picture.large,
        status: nil
      )
    }
  }
}
