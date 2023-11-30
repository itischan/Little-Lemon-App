import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ExampleDatabase")
        container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: {_,_ in })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func clear() {
        // Delete all dishes from the store
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dish")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else { continue }
                container.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(container) error:", error)
        }
    }
}
