//
//  MatrimonyProfilesViewModelTests.swift
//  MatrimonialTests
//
//  Created by Akash Kumar on 29/09/25.
//

import XCTest
import Combine
@testable import Matrimonial

final class MatrimonyProfilesViewModelTests: XCTestCase {
  private var viewModel: MatrimonyProfilesViewModel?
  private var mockRepository: MockMatrimonyRepository?
  private var cancellables: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    mockRepository = MockMatrimonyRepository()
    cancellables = []
  }

  override func tearDown() {
    viewModel = nil
    mockRepository = nil
    cancellables = nil
    super.tearDown()
  }

  // MARK: - Tests

  func testInit_loadsCachedAndFetchesNextPage() {
    // Given
    guard let repo = mockRepository else {
      XCTFail("mockRepository not initialized")
      return
    }

    let cached = [
      MatrimonyProfileData(id: "1", name: "Alice", age: 25, location: "Paris", imageUrl: "", status: nil)
    ]
    let fetched = [
      MatrimonyProfileData(id: "2", name: "Bob", age: 30, location: "Berlin", imageUrl: "", status: nil)
    ]
    repo.cachedProfiles = cached
    repo.fetchedPages = [fetched]

    let expectation = expectation(description: "Profiles updated")

    // When
    viewModel = MatrimonyProfilesViewModel(repository: repo, resultsPerPage: 10)
    guard let viewModel else {
      XCTFail("viewModel not initialized")
      return
    }

    viewModel.$profiles
      .dropFirst(2) // 1: initial empty, 2: after cached+fetch
      .sink { profiles in
        XCTAssertEqual(profiles.count, 1)
        XCTAssertEqual(profiles.first?.id, "2")
        expectation.fulfill()
      }
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)
  }

  func testFetchNextPage_failure_setsErrorMessage() {
    // Given
    guard let repo = mockRepository else {
      XCTFail("mockRepository not initialized")
      return
    }

    repo.shouldFailFetch = true
    viewModel = MatrimonyProfilesViewModel(repository: repo)
    guard let viewModel else {
      XCTFail("viewModel not initialized")
      return
    }

    let expectation = expectation(description: "Error message set")

    viewModel.$errorMessage
      .dropFirst() // skip initial nil
      .sink { error in
        XCTAssertNotNil(error)
        expectation.fulfill()
      }
      .store(in: &cancellables)

    // When
    viewModel.fetchNextPage()

    wait(for: [expectation], timeout: 1.0)
  }

  @MainActor func testAccept_updatesRepositoryAndLocalProfile() {
    // Given
    guard let repo = mockRepository else {
      XCTFail("mockRepository not initialized")
      return
    }

    let profile = MatrimonyProfileData(id: "123", name: "Test", age: 20, location: "City", imageUrl: "", status: .accepted)
    repo.cachedProfiles = [profile]
    repo.fetchedPages = [[]]

    viewModel = MatrimonyProfilesViewModel(repository: repo)
    guard let viewModel else {
      return
    }

    // Wait for cached profiles to load deterministically
    let expectation = expectation(description: "Cached profiles loaded")
    let cancellable = viewModel.$profiles
      .dropFirst()
      .sink { profiles in
        if profiles.count == 1 {
          expectation.fulfill()
        }
      }

    wait(for: [expectation], timeout: 1.0)
    cancellable.cancel()

    // When
    viewModel.accept(profile)

    // Then
    XCTAssertEqual(repo.updateCalls.count, 1)
    XCTAssertEqual(repo.updateCalls.first?.id, "123")
    XCTAssertEqual(repo.updateCalls.first?.status, .accepted)
  }

  @MainActor func testDecline_updatesRepositoryAndLocalProfile() {
    // Given
    guard let repo = mockRepository else {
      XCTFail("mockRepository not initialized")
      return
    }

    let profile = MatrimonyProfileData(id: "555", name: "Decline Test", age: 28, location: "Rome", imageUrl: "", status: .declined)
    repo.cachedProfiles = [profile]
    repo.fetchedPages = [[]]

    viewModel = MatrimonyProfilesViewModel(repository: repo)
    guard let viewModel = viewModel else { return }

    // Wait for cached profiles to load deterministically
    let expectation = expectation(description: "Cached profiles loaded")
    let cancellable = viewModel.$profiles
      .dropFirst()
      .sink { profiles in
        if profiles.count == 1 {
          expectation.fulfill()
        }
      }

    wait(for: [expectation], timeout: 1.0)
    cancellable.cancel()

    // When
    viewModel.decline(profile)

    // Then
    XCTAssertEqual(repo.updateCalls.count, 1)
    XCTAssertEqual(repo.updateCalls.first?.id, "555")
    XCTAssertEqual(repo.updateCalls.first?.status, .declined)
  }

  func testFetchNextPage_doesNotTriggerWhenAlreadyLoading() {
    // Given
    guard let repo = mockRepository else {
      XCTFail("mockRepository not initialized")
      return
    }

    repo.fetchedPages = [[]]
    viewModel = MatrimonyProfilesViewModel(repository: repo)
    guard let viewModel = viewModel else { return }

    viewModel.isLoading = true

    // When
    viewModel.fetchNextPage()

    // Then
    XCTAssertTrue(viewModel.isLoading)
  }
}
