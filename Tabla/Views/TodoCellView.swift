

import UIKit

//Observer pattern para que los cambios de esta View sean notificados a los observadores, esto es al controlador(es)
protocol TodoCellViewObserver {
    func checked(cell: UITableViewCell, isNowChecked: Bool) -> Void
}

class TodoCellView: UITableViewCell {

    private var observers: [TodoCellViewObserver] = []

    func addObserver(_ observer: TodoCellViewObserver) {
        self.observers.append(observer)
    }

    @IBOutlet var lblTitle: UILabel! //Por qué con weak no funciona el tachado?? testear
    @IBOutlet weak var txtContent: UITextField!
    @IBOutlet weak var chkChecked: UISwitch!

    @IBAction func onChkChanged(_ sender: UISwitch) {
        //Notifico a todos los observers de que cambió el estado del check
        observers.forEach({$0.checked(cell: self, isNowChecked: sender.isOn)})
        //Tachar / destachar texto
        setCompletionState(check: sender)
    }

    func set(title: String, content: String, checked: Bool) {
        lblTitle.text = title
        txtContent.text = content
        chkChecked.isOn = checked
        setCompletionState(check: chkChecked)
    }

    func setCompletionState(check: UISwitch) {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: lblTitle.text ?? "")
        if check.isOn {
            attributeString.addAttribute(.strikethroughStyle,
                                         value: 2,
                                         range: NSRange(location: 0, length: attributeString.length))
        } else {
            attributeString.removeAttribute(.strikethroughStyle,
                                            range: NSRange(location: 0, length: attributeString.length))
        }
        lblTitle.attributedText = attributeString

    }
}
