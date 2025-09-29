//
//  ProfileEntity+CoreDataProperties.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//
//

import Foundation
import CoreData


extension ProfileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileEntity> {
        return NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var fullName: String?
    @NSManaged public var age: Int16
    @NSManaged public var location: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var status: String?

}

extension ProfileEntity : Identifiable {

}
