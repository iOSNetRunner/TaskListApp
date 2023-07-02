//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Dmitrii Galatskii on 01.07.2023.
//

import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    var taskList: [Task] = []
    var persistentContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func createData(with taskName: String) {
        let context = persistentContainer.viewContext
        let task = Task(context: context)
        task.title = taskName
        taskList.append(task)
    }
    
    func readData() {
        let context = persistentContainer.viewContext
        let fetchRequest = Task.fetchRequest()
        
        do {
           taskList = try context.fetch(fetchRequest)
        } catch {
            
        }
    }
    
    func updateData() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Task successfuly saved!")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteData(for selectedTask: Task) {
        let context = persistentContainer.viewContext
        context.delete(selectedTask)
        if context.hasChanges {
            do {
                try context.save()
                print("Task successfully removed!")
            } catch {
                print(error)
            }
        }
    }
    
    private init () {}
    
}
