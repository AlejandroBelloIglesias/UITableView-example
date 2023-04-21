import UIKit

//protocol TodoFormControllerDelegate: AnyObject {
//    func modifyEvent(delegator: TodoFormController, todo: Todo)
//}

class TodoFormController: UIViewController {
    //weak var delegate: TodoFormControllerDelegate?
    weak var todo: Todo? = nil // nil means creating Todo, assigned means updating Todo
    //The action to perform when the user accepts the form
    var action: (_ title: String, _ content: String) -> Void = { title, content in }

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtContent: UITextField!

    enum State {
        case insert
        case modify(todo: Todo)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let todo = self.todo {
            self.txtTitle.text = todo.title
            self.txtContent.text = todo.content
        }
    }

    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true)
        todo = nil
    }

    @IBAction func onAccept(_ sender: Any) {
        if let title = txtTitle.text {
            action(title, txtContent.text ?? "")
        }
        dismiss(animated: true)
    }
}
