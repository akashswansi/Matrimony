//
//  MatrimonyAPIRequest.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import Foundation
enum MatrimonyAPIRequest {
  // Replace this with creating a new enum which can give different endpoints
  private enum Constant {
    static let baseURL = "https://randomuser.me"
    static let endPoint = "/api/"
  }
  case profiles(page: Int, results: Int)

  private var baseURLString: String {
    Constant.baseURL
  }

  private var path: String {
    switch self {
    case .profiles:
      return Constant.endPoint
    }
  }

  private var method: String {
    switch self {
    case .profiles:
      return "GET"
    }
  }

  private var queryItems: [URLQueryItem] {
    switch self {
    case .profiles(let page, let results):
      return [
        URLQueryItem(name: "results", value: "\(results)"),
        URLQueryItem(name: "page", value: "\(page)")
      ]
    }
  }

  func buildURLRequest() throws -> URLRequest {
    guard let baseURL = URL(string: baseURLString) else {
      throw MatrimonyAPIError.invalidBaseURL
    }

    guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
      throw MatrimonyAPIError.invalidURLComponents
    }

    components.queryItems = queryItems

    guard let finalURL = components.url else {
      throw MatrimonyAPIError.invalidFinalURL
    }

    var request = URLRequest(url: finalURL)
    request.httpMethod = method
    request.timeoutInterval = 30
    return request
  }
}
