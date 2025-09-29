//
//  MatrimonyProfilesListView.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import SwiftUI

struct MatrimonyProfilesListView: View {
  @StateObject private var viewModel = MatrimonyProfilesViewModel()
  @State private var showRetryAlert = false

  var body: some View {
    NavigationView {
      Group {
        if viewModel.isLoading && viewModel.profiles.isEmpty {
          progressView
        } else if viewModel.profiles.isEmpty {
          placeholderView
        } else {
          contentView
        }
      }
      .navigationTitle("Matrimony Profiles")
      .alert(isPresented: $showRetryAlert) {
        Alert(
          title: Text("Error"),
          message: Text(viewModel.errorMessage ?? "Failed to load profiles. Please try again."),
          primaryButton: .default(Text("Try Again")) {
            viewModel.fetchNextPage()
          },
          secondaryButton: .cancel()
        )
      }
      .alert(item: Binding(
        get: { viewModel.errorMessage.map { ErrorWrapper(message: $0) } },
        set: { _ in viewModel.errorMessage = nil }
      )) { wrapper in
        Alert(
          title: Text("Error"),
          message: Text(wrapper.message),
          dismissButton: .default(Text("OK"))
        )
      }
    }
  }

  private var progressView: some View {
    VStack {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
      Text("Loading profiles...")
        .foregroundColor(.gray)
        .padding(.top, 8)
    }
    .frame(height: 280)
    .frame(maxWidth: .infinity)
  }

  private var placeholderView: some View {
    VStack {
      Image(systemName: "person.2.slash")
        .resizable()
        .scaledToFit()
        .frame(width: 100, height: 280)
        .foregroundColor(.gray)
      Text("No profiles found")
        .foregroundColor(.gray)
        .padding(.top, 8)

      Button(action: {
        showRetryAlert = true
      }) {
        Text("Try Again")
          .bold()
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
          .padding(.horizontal, 40)
          .padding(.top, 16)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private var contentView: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        ForEach(viewModel.profiles) { profile in
          ProfileCardView(
            profile: profile,
            onAccept: { viewModel.accept(profile) },
            onDecline: { viewModel.decline(profile) }
          )
          .onAppear {
            if profile == viewModel.profiles.last {
              viewModel.fetchNextPage()
            }
          }
        }

        if viewModel.isLoading {
          ProgressView().padding()
        }
      }
      .padding(.horizontal)
    }
  }
}

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}
