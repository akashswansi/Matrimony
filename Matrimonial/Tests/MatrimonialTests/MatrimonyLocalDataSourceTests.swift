//
//  MatrimonyLocalDataSourceTests.swift
//  MatrimonialTests
//
//  Created by Akash Kumar on 29/09/25.
//

import XCTest
import CoreData
@testable import Matrimonial

final class MatrimonyLocalDataSourceTests: XCTestCase {
  private var dataSource: MatrimonyLocalDataSource?
  private var context: NSManagedObjectContext?

  override func setUp() {
    super.setUp()
    context = CoreDataTestHelper.makeInMemoryContext()
    if let context = context {
      dataSource = MatrimonyLocalDataSource(context: context)
    }
  }
  
  override func tearDown() {
    dataSource = nil
    context = nil
    super.tearDown()
  }

  func testSaveAndFetchProfiles_success() {
    // Given
    guard let dataSource = dataSource else {
      XCTFail("DataSource not initialized")
      return
    }

    let profiles = [
      MatrimonyProfileData(
        id: "1",
        name: "Alice",
        age: 25,
        location: "Paris",
        imageUrl: "https://randomuser.me/api/portraits/women/1.jpg",
        status: .accepted
      ),
      MatrimonyProfileData(
        id: "2",
        name: "Bob",
        age: 30,
        location: "Berlin",
        imageUrl: "https://randomuser.me/api/portraits/men/1.jpg",
        status: .declined
      )
    ]

    // When
    dataSource.save(profiles: profiles)
    let fetched = dataSource.fetchAll()

    // Then
    XCTAssertEqual(fetched.count, 2)
    XCTAssertEqual(fetched.first?.name, "Alice")
    XCTAssertEqual(fetched.last?.status, .declined)
  }

  func testUpdateStatus_updatesExistingProfile() {
    guard let dataSource = dataSource else {
      XCTFail("DataSource not initialized")
      return
    }

    let profile = MatrimonyProfileData(
      id: "1",
      name: "Charlie",
      age: 28,
      location: "Rome",
      imageUrl: "",
      status: nil
    )
    dataSource.save(profiles: [profile])

    dataSource.updateStatus(profileID: "1", status: .accepted)
    let fetched = dataSource.fetchAll()

    XCTAssertEqual(fetched.count, 1)
    XCTAssertEqual(fetched.first?.status, .accepted)
  }

  func testFetchAll_whenEmpty_returnsEmptyArray() {
    guard let dataSource = dataSource else {
      XCTFail("DataSource not initialized")
      return
    }
    let fetched = dataSource.fetchAll()
    XCTAssertTrue(fetched.isEmpty)
  }
}
