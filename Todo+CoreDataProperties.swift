//
//  Todo+CoreDataProperties.swift
//  TodoAppExample
//
//  Created by 한상욱 on 10/3/25.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var content: String?

}

extension Todo : Identifiable {

}
