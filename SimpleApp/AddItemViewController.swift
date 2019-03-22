//
//  AddItemViewController.swift
//  SimpleApp
//
//  Created by evhive on 20/03/19.
//  Copyright © 2019 Coco. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    func didCancel()
    func didAddTask(task: Tasks?)

}


class AddItemViewController: UIViewController {
    
    var delegate: AddItemViewControllerDelegate!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var taskTextView: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any  additional setup after loading the view, typically from a nib.
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate.didCancel()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        delegate.didAddTask(task: makeTask())

    }
    @IBAction func dismissKeyboardButtonPressed(_ sender: UIButton) {
        view.endEditing(false)

    }
    func makeTask() -> Tasks? {
        let task = Tasks(title: titleTextField.text, task: taskTextView.text, dueDate: datePicker.date, isCompleted: "NO")
        
        return task
    }
}
