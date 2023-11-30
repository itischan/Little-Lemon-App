//
//  Dish+CoreDataClass.swift
//  LittleLemon
//
//  Created by Chandru Kumaran on 11/28/23
//
//

import Foundation
import CoreData


public class Dish: NSManagedObject {

}


extension Dish {
    
    static func createDishesFrom(menuItems: [MenuItem], _ context: NSManagedObjectContext) {
        for item in menuItems {
            let dish = Dish(context: context)
            dish.title = item.title
            dish.image = item.image
            dish.price = item.price
            dish.itemDescription = item.description
            do {
                try context.save()
            } catch let error {
                print("Error saving Dish object to core data, \(error.localizedDescription)")
            }
        }
    }
    
}
