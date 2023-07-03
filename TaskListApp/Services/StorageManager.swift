//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Dmitrii Galatskii on 01.07.2023.
//

import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    //MARK: - Core Data Stack
    private let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init () {
        viewContext = persistentContainer.viewContext
    }
    
    
    //MARK: - Core Data Saving Support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                print("CoreData: operation successful")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //MARK: - CRUD Methods
    func createData(with taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = taskName
        completion(task)
        saveContext()
        
    }
    
    func readData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
            print("CoreData: read successful")
        } catch {
            completion(.failure(error))
        }
    }
    
    func updateData(for selectedTask: Task, with title: String) {
        selectedTask.title = title
        saveContext()
    }
    
    
    func deleteData(for selectedTask: Task) {
        viewContext.delete(selectedTask)
        saveContext()
    }
}
