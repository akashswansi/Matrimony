//
//  ProfileCardView.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileCardView: View {
  let profile: MatrimonyProfileData
  var onAccept: () -> Void
  var onDecline: () -> Void

  var body: some View {
    VStack(spacing: 8) {
      profileImageView
      profileNameView
      profileAgeView
      profileActionView
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.white)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
    )
    .padding(.horizontal)
  }

  private var profileImageView: some View {
    WebImage(url: URL(string: profile.imageUrl))
      .resizable()
      .scaledToFill()
      .frame(height: 280)
      .frame(maxWidth: .infinity)
      .clipped()
      .cornerRadius(12)
      .background(Color.gray.opacity(0.1))
  }

  private var profileNameView: some View {
    Text(profile.name)
      .font(.headline)
      .foregroundColor(.primary)
      .frame(maxWidth: .infinity, alignment: .center)
  }

  private var profileAgeView: some View {
    Text("\(profile.age), \(profile.location)")
      .font(.subheadline)
      .foregroundColor(.secondary)
      .frame(maxWidth: .infinity, alignment: .center)
  }

  @ViewBuilder
  private var profileActionView: some View {
    if let status = profile.status {
      statusView(for: status)
    } else {
      actionButtons
    }
  }

  @ViewBuilder
  private var actionButtons: some View {
    HStack(spacing: 32) {
      Button(action: onDecline) {
        Image(systemName: "xmark")
          .font(.title2)
          .foregroundColor(.red)
          .padding()
          .background(Circle().fill(Color.red.opacity(0.1)))
      }

      Button(action: onAccept) {
        Image(systemName: "checkmark")
          .font(.title2)
          .foregroundColor(.green)
          .padding()
          .background(Circle().fill(Color.green.opacity(0.1)))
      }
    }
    .padding(.top, 8)
  }

  @ViewBuilder
  private func statusView(for status: MatrimonyProfileStatus) -> some View {
    Text(status.rawValue.capitalized)
      .font(.subheadline)
      .fontWeight(.medium)
      .foregroundColor(.white)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 8)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(status == .accepted ? Color.green : Color.red)
      )
      .padding(.top, 8)
  }
}
