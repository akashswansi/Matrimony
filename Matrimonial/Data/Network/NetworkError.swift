//
//  NetworkError.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import Foundation
enum MatrimonyAPIError: Error, LocalizedError {
  case invalidBaseURL
  case invalidURLComponents
  case invalidFinalURL

  // MARK: Added few custom error can add more error based on error code's
  var errorDescription: String? {
    switch self {
    case .invalidBaseURL:
      return "Invalid base URL."
    case .invalidURLComponents:
      return "Failed to build URL components."
    case .invalidFinalURL:
      return "Failed to construct final URL."
    }
  }
}

enum MatrimonyLocalDataError: LocalizedError {
  case fetchFailed(Error)
  case saveFailed(Error)
  case updateFailed(Error)
  
  var errorDescription: String? {
    switch self {
    case .fetchFailed(let error):
      return "Failed to fetch profiles: \(error.localizedDescription)"
    case .saveFailed(let error):
      return "Failed to save profiles: \(error.localizedDescription)"
    case .updateFailed(let error):
      return "Failed to update status: \(error.localizedDescription)"
    }
  }
}
