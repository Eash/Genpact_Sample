//
//  ReceipeItem+CoreDataProperties.swift
//  AppTest
//
//  Created by Ganesh Kumar on 15/09/19.
//  Copyright © 2019 Nextbrain. All rights reserved.
//
//

import Foundation
import CoreData


extension ReceipeItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReceipeItem> {
        return NSFetchRequest<ReceipeItem>(entityName: "ReceipeItem")
    }

    @NSManaged public var mealId: String?
    @NSManaged public var mealName: String?
    @NSManaged public var mealCategory: String?
    @NSManaged public var mealArea: String?
    @NSManaged public var mealInstruction: String?
    @NSManaged public var mealsImage: String?

}
