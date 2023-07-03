//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Dmitrii Galatskii on 01.07.2023.
//

import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    
    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init () {}
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("CoreData: operation successful")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createData(with taskName: String) -> Task {
        let task = Task(context: context)
        task.title = taskName
        saveContext()
        return task
    }
    
    func readData() -> NSFetchRequest<Task> {
        let fetchRequest = Task.fetchRequest()
        return fetchRequest
    }
    
    func updateData(for selectedTask: Task, with title: String) {
        selectedTask.title = title
        saveContext()
    }
    
    
    func deleteData(for selectedTask: Task) {
        context.delete(selectedTask)
        saveContext()
    }
}
