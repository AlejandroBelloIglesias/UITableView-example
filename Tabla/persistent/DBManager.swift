import CoreData
import UIKit

class DBManager {
    static let shared = DBManager()
    
    private init() {} //Private init to avoid creating more than one instance

    //3
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tabla")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    

    //CRUD functions

    func todos() -> [Todo] {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        var todos: [Todo] = []
        do {
            todos = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetching todos")
        }
        return todos
    }

    func todo(title: String, content: String) -> Todo {
        let todo = Todo(context: persistentContainer.viewContext)
        todo.title = title
        todo.content = content
        todo.checked = false
        save()
        return todo
    }
    

    func delete(_ object: NSManagedObject) {
        self.persistentContainer.viewContext.delete(object)
    }    


    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

