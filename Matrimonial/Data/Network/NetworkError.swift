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
