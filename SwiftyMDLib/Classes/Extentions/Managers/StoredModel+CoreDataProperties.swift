//
//  StoredModel+CoreDataProperties.swift
//
//
//  Created by Sargis Gevorgyan on 3/10/20.
//
//

import Foundation
import CoreData


extension StoredModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredModel> {
        return NSFetchRequest<StoredModel>(entityName: "StoredModel")
    }

    @NSManaged public var data: Data?
    @NSManaged public var key: String?
    @NSManaged public var isKeepingPermonantly: Bool
}
