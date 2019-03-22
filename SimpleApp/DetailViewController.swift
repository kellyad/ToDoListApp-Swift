//
//  DetailViewController.swift
//  SimpleApp
//
//  Created by evhive on 21/03/19.
//  Copyright © 2019 Coco. All rights reserved.
//

import UIKit


protocol DetailViewControllerDelegate: class {
    func didSaveTask(task: Tasks?, at indexPath: IndexPath)

    
}


class DetailViewController: UIViewController, EditViewControllerDelegate {

    
    var delegate: DetailViewControllerDelegate!
    var task: Tasks?
    var taskIndexPath: IndexPath?

    @IBOutlet var isCompleteButton: UIButton!
    @IBOutlet var taskTextField: UILabel!
    @IBOutlet var dateTextField: UILabel!
    @IBOutlet var titleTextField: UILabel!
    @IBOutlet var editButton: UIBarButtonItem!
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
    }
    @IBAction func isCompleteButtonPressed(_ sender: UIButton) {
        if (task!.isCompleted == "YES") {
            task!.isCompleted = "NO"
        } else {
            task!.isCompleted = "YES"
        }

        delegate.didSaveTask(task: task, at: taskIndexPath!)
        navigationController?.popToRootViewController(animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"

    var dueDate: String? = nil
    
        dueDate = dateFormatter.string(from: task!.dueDate )
        titleTextField.text = task!.title
        taskTextField.text = task!.task
        dateTextField.text = dueDate

        if (task!.isCompleted == "YES") {
            print("completed", task!.isCompleted)
            print(task!.isCompleted)
            isCompleteButton.setTitle("Mark as incomplete", for: UIControl.State.normal)
        } else {
            isCompleteButton.setTitle("Mark as complete", for: UIControl.State.normal)
        }

        // Do any  additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "to editVC") {
            if (segue.destination is EditViewController) {

                let editVC = segue.destination as? EditViewController
                editVC?.delegate = self

                editVC?.task = task
            }
        }
    }

    
    func didSaveTask(_ task: Tasks?) {
        if let task = task {
            print("detailVC got the saved task \(task)")
        }

        delegate.didSaveTask(task: task, at: taskIndexPath!)
    }

    
}
