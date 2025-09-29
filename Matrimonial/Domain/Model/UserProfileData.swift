//
//  UserProfileData.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

struct UserProfileData: Codable {
    let results: [UserProfile]
}

struct UserProfile: Codable {
  struct Name: Codable {
    let title: String; let first: String; let last: String
  }

  struct DOB: Codable {
    let age: Int
  }

  struct Login: Codable {
    let uuid: String
  }

  struct Picture: Codable {
    let large: String
  }

  struct Location: Codable {
    let city: String; let state: String
  }

  let name: Name
  let dob: DOB
  let login: Login
  let picture: Picture
  let location: Location
}
