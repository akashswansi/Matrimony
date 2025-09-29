//
//  MatrimonyLocalDataSourceProtocol.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import Foundation
protocol MatrimonyLocalDataSourceProtocol {
    func fetchAll() -> [MatrimonyProfileData]
    func save(profiles: [MatrimonyProfileData])
    func updateStatus(profileID: String, status: MatrimonyProfileStatus)
}
