//
//  EditViewController.swift
//  SimpleApp
//
//  Created by evhive on 21/03/19.
//  Copyright © 2019 Coco. All rights reserved.
//

import UIKit

protocol EditViewControllerDelegate: class {
    func didSaveTask(_ task: Tasks?)
    
}


class EditViewController: UIViewController {
    
    var delegate:EditViewControllerDelegate!
    var task:Tasks?
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var taskTextView: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let editedTask = Tasks(title: titleTextField.text, task: taskTextView.text, dueDate: datePicker.date, isCompleted: task!.isCompleted)

        delegate.didSaveTask(editedTask)
        navigationController?.popToRootViewController(animated: true)

    }
    
    @IBAction func dismissKeyboardButtonPressed(_ sender: UIButton) {
        view.endEditing(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTextField.text = self.task!.title;
        self.taskTextView.text = self.task!.task;
        self.datePicker.date = self.task!.dueDate;
    }
}
