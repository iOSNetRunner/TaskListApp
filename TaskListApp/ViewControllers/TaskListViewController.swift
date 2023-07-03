//
//  ViewController.swift
//  TaskListApp
//
//  Created by Vasichko Anna on 29.06.2023.
//

import UIKit

final class TaskListViewController: UITableViewController {
    
    private let cellID = "task"
    
    private let storageManager = StorageManager.shared
    private var selectedIndex: Int!
    private var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        fetchData()
    }
    
    
    
    @objc private func addNewTask() {
        showAlert(withTitle: "New Task", andMessage: "What would you like to do?")
    }
    
    private func fetchData() {
        do {
            taskList = try storageManager.context.fetch(
                storageManager.readData()
            )
        }
        catch {
            
        }
        
    }
    
    private func save(_ taskName: String) {
        let newTask = storageManager.createData(with: taskName)
        taskList.append(newTask)
        
        tableView.insertRows(
            at: [IndexPath(row: taskList.count - 1, section: 0)],
            with: .automatic)
    }
    
    private func edit(_ taskName: String) {
        storageManager.updateData(
            for: taskList[selectedIndex],
            with: taskName)
        
        tableView.reloadRows(
            at: [IndexPath(row: selectedIndex, section: 0)],
            with: .automatic)
    }
    
    
    
    private func showAlert(withTitle title: String, andMessage message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save Task", style: .default) { [unowned self] _ in
            guard let taskName = alert.textFields?.first?.text, !taskName.isEmpty else { return }
            save(taskName)
        }
        
        let editAction = UIAlertAction(title: "Update Task", style: .default) { [unowned self] _ in
            guard let taskRename = alert.textFields?.first?.text, !taskRename.isEmpty else { return }
            edit(taskRename)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        if !tableView.isEditing {
            alert.addAction(saveAction)
            alert.addTextField { textField in
                textField.placeholder = "New Task"
            }
        } else {
            alert.addAction(editAction)
            alert.addTextField { [unowned self] textfield in
                textfield.text = taskList[selectedIndex].title
            }
        }
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        tableView.isEditing = false
    }
    
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isEditing = true
        selectedIndex = indexPath.row
        showAlert(withTitle: "Update Task", andMessage: "Edit your selected task")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let objectToDelete = taskList.remove(at: indexPath.row)
            storageManager.deleteData(for: objectToDelete)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


// MARK: - Setup UI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(named: "MainBlue")
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }
}
