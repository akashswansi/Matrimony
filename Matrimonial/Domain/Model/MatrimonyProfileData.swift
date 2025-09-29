//
//  MatrimonyProfileData.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import Foundation
struct MatrimonyProfileData: Identifiable, Hashable, Equatable {
    let id: String
    let name: String
    let age: Int
    let location: String
    let imageUrl: String
    var status: MatrimonyProfileStatus?
}
