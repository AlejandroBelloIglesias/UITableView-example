//
//  ViewController.swift
//  Tabla
//
//  Created by Alejandro Bello Iglesias on 19/12/22.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet var tblTodo: UITableView!
    var todos:[Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //Fetch
        self.todos = DBManager.shared.todos()
        tblTodo.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "todoInsertSegue":
                guard let todoFormController = segue.destination as? TodoFormController else { return }
                todoFormController.action = { [weak self] (title, content) in
                    guard let self = self else { return }
                    let todo = DBManager.shared.todo(title: title, content: content)
                    DBManager.shared.save()
                    //UI insertion
                    self.todos.append(todo)
                    self.tblTodo.reloadData()
                }
            case "todoModifySegue":
                guard let todoFormController = segue.destination as? TodoFormController else { return }
                //Sending up the todo to be modified to the subview
                guard let sender = sender as? TodoCellView else { return }
                guard let indexPath = tblTodo.indexPath(for: sender) else { return }

                //todoFormController.delegate = self
                todoFormController.todo = todos[indexPath.row]
                todoFormController.action = { [weak self] (title, content) in
                    guard let self = self else { return }
                    //Modify array
                    self.todos[indexPath.row].title = title
                    self.todos[indexPath.row].content = content
                    //Save persistence
                    DBManager.shared.save()
                    //UI modification
                    self.tblTodo.reloadRows(at: [indexPath], with: .automatic)
                }
            default:
                break
        }
        
    }
}


extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tblTodo = tableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoCellView
        cell.set(title: todos[indexPath.row].title!,
                 content: todos[indexPath.row].content ?? "",
                 checked: todos[indexPath.row].checked)
        cell.addObserver(self) //De esta forma self recibe eventos de cell
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Coredata deletion
            let context = DBManager.shared.persistentContainer.viewContext
            context.delete(todos[indexPath.row])
            DBManager.shared.save()
            //UI deletion
            todos.remove(at: indexPath.row)
            tblTodo.beginUpdates()
            tblTodo.deleteRows(at: [indexPath], with: .automatic)
            tblTodo.endUpdates()
        }
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

//Observer for cell check
extension ViewController: TodoCellViewObserver {
    func checked(cell: UITableViewCell, isNowChecked: Bool) {
        //Modificar array
        //Tachar/destachar texto
        guard let indexPath = tblTodo.indexPath(for: cell) else { return }
        todos[indexPath.row].checked = isNowChecked

        //Save persistence
        DBManager.shared.save()
    }
    
}
