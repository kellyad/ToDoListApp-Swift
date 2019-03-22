//
//  ViewController.swift
//  SimpleApp
//
//  Created by evhive on 14/03/19.
//  Copyright © 2019 Coco. All rights reserved.
//

import UIKit

let OVERDUE_TASKS = "overdueTasks"
let COMPLETED_TASKS = "completedTasks"
let ARRAY_OF_DICTIONARIES = "arrayOfDictionaries"

class ViewController: UIViewController,UITableViewDelegate,UITabBarDelegate, UITableViewDataSource, AddItemViewControllerDelegate, DetailViewControllerDelegate {


    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIBarButtonItem!
    
    var today:Date!

    lazy var allTasks = [AnyObject]()
    lazy var overdueTasks = [AnyObject]()
    lazy var completedTasks = [AnyObject]()
   
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            sender.title = "Edit"
            tableView.setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            tableView.setEditing(true, animated: true)
        }
    }
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "to addItemVC",sender: sender);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        today = Date()
        loadTasks()
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = true

        // Do any additional setup after loading the view, typically from a nib.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)? ) {
        if (segue.identifier == "to addItemVC") {
            if (segue.destination is AddItemViewController ) {

                let addItemVC = segue.destination as? AddItemViewController
                            addItemVC?.delegate = self
                        }

            }else
if (segue.identifier == "to detailVC") {
    if (segue.destination is DetailViewController) {

        var detailVC = segue.destination as? DetailViewController
        
        var indexPath:IndexPath =  sender as! IndexPath

        var task: Tasks?

        //find where the task is
        if indexPath.section == 0 {
            task = allTasks[indexPath.row] as? Tasks
        } else if indexPath.section == 1 {
            task = overdueTasks[indexPath.row ?? 0] as? Tasks
        } else {
            task = completedTasks[indexPath.row ?? 0] as? Tasks
        }

        detailVC?.delegate = self
        detailVC?.task = task
        detailVC?.taskIndexPath = indexPath as IndexPath
    }
}

        
    }
    
func numberOfSections(in tableView: UITableView) -> Int {
    return 3
}

func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 1 {
        if overdueTasks.count > 0 {
            return "Overdue tasks"
        }
    } else if section == 2 {
        if completedTasks.count > 0 {
            return "completed tasks"
        }
    } else {
        return "Current tasks"
    }
    return ""
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 {
        return overdueTasks.count
    } else if section == 2 {
        return completedTasks.count
    } else {
        return allTasks.count
    }
}
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

    var task: Tasks?

    //get the task at indexPath
    if indexPath.section == 0 {
        task = allTasks[indexPath.row] as? Tasks
    } else if indexPath.section == 1 && overdueTasks.count > 0 {
        task = overdueTasks[indexPath.row] as? Tasks
    } else if indexPath.section == 2 && completedTasks.count > 0 {
        task = completedTasks[indexPath.row] as? Tasks
    }

    //create dateformatter
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"

    var dueDate: String? = nil
     dueDate = dateFormatter.string(from: (task?.dueDate)!)
    

    cell.textLabel?.text = task?.title
    cell.detailTextLabel?.text = dueDate

    //check the state of task
    if (task?.isCompleted == "YES") {
        cell.backgroundColor = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 0.5)
    } else if isOverdue(task?.dueDate) {
        cell.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 0.5)
    } else {
        cell.backgroundColor = UIColor.clear
    }

    return cell
}



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    //get the task, remove from array
    var task: Tasks?
    if indexPath.section == 1 {
        task = overdueTasks[indexPath.row] as? Tasks
        overdueTasks.remove(at: indexPath.row)
    } else if indexPath.section == 2 {
        task = completedTasks[indexPath.row] as? Tasks
        completedTasks.remove(at: indexPath.row)
    } else {
        task = allTasks[indexPath.row] as? Tasks
        allTasks.remove(at: indexPath.row)
    }

    //chage the completed state
    if (task?.isCompleted == "YES") {
        task?.isCompleted = "NO"
    } else {
        task?.isCompleted = "YES"
    }

    //add the task back
    //[self.allTasks insertObject:task atIndex:indexPath.row];

    if indexPath.section == 1 || indexPath.section == 0 {
        if let task = task {
            completedTasks.append(task)
        }
    } else if isOverdue(task?.dueDate) {
        if let task = task {
            overdueTasks.append(task)
           // overdueTasks.append(task)
        }
    } else {
        if let task = task {
            allTasks.append(task)
            //allTasks.append(task)
        }
    }

    saveTasks()
    tableView.reloadData()
}

func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
}

func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //delete here
    if editingStyle == .delete {

        //check were the delete section is called from
        if indexPath.section == 1 {
            overdueTasks.remove(at: indexPath.row)
        } else if indexPath.section == 2 {
            completedTasks.remove(at: indexPath.row)
        } else {
            allTasks.remove(at: indexPath.row)
        }

        saveTasks()
        tableView.deleteRows(at: [indexPath], with: .fade)
        self.tableView.reloadData()
    }
}
    
func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {

    var fromTask: Tasks?

    //remove from old location
    if fromIndexPath.section == 0 {
        fromTask = allTasks[fromIndexPath.row] as? Tasks
        allTasks.remove(at: fromIndexPath.row)
    } else if fromIndexPath.section == 1 {
        fromTask = overdueTasks[fromIndexPath.row] as? Tasks
        overdueTasks.remove(at: fromIndexPath.row)
    } else {
        fromTask = completedTasks[fromIndexPath.row] as? Tasks
        completedTasks.remove(at: fromIndexPath.row)
    }

    //insert to new location
    if toIndexPath.section == 0 {
        print("moving to normal")
        fromTask?.isCompleted = "NO"
        if let fromTask = fromTask {
            allTasks.insert(fromTask, at: toIndexPath.row )
        }
    } else if toIndexPath.section == 1 {
        fromTask?.isCompleted = "NO"
        print("moving to overdue")
        if let fromTask = fromTask {
            overdueTasks.insert(fromTask, at: toIndexPath.row )
        }
    } else {
        print("moving to completed")
        fromTask?.isCompleted = "YES"
        if let fromTask = fromTask {
            completedTasks.insert(fromTask, at: toIndexPath.row )
        }
    }

    //reload and save
    self.tableView.reloadData()
    saveTasks()
}

func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
}

func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    performSegue(withIdentifier: "to detailVC", sender: indexPath)
}

    func dictionary(fromTask task: Tasks?) -> [String:Any]? {
    let dictionary = [
    "title": task!.title,
    "task": task!.task,
    "dueDate": task!.dueDate,
    "isCompleted": task!.isCompleted
        ] as [String : Any]

return dictionary

}
    
func loadTasks() {

    let loadedTasks = UserDefaults.standard.object(forKey: ARRAY_OF_DICTIONARIES) as? [Tasks]
    let loadedcompletedTasks = UserDefaults.standard.object(forKey: COMPLETED_TASKS) as? [Tasks]
    let loadOverdueTasks = UserDefaults.standard.object(forKey: OVERDUE_TASKS) as? [Tasks]
    print(loadOverdueTasks)
    for dictionary in loadedTasks ?? [] {
        let task: Tasks = dictionary as! Tasks
        if (task.isCompleted == "YES") {
            completedTasks.append(task)
        } else if isOverdue(task.dueDate) {
            overdueTasks.append(task)
        } else {
            allTasks.append(task)
        }
    }

    for dictionary in loadedcompletedTasks ?? []{
        let task: Tasks = dictionary as! Tasks

        if (task.isCompleted == "YES") {
            completedTasks.append(task)
        } else if isOverdue(task.dueDate) {
            overdueTasks.append(task)
        } else {
            allTasks.append(task)
        }
    }

    for dictionary in loadOverdueTasks ?? []{
        let task: Tasks = dictionary

        if (task.isCompleted == "YES") {
            completedTasks.append(task)
        } else if isOverdue(task.dueDate) {
            overdueTasks.append(task)
        } else {
            allTasks.append(task)
        }
    }
}

func saveTasks()
{

var userDefaults = UserDefaults()

var saveArray: [Any] = []
var saveCompletedArray: [Any] = []
    var saveOverdueArray: [Any] = []


for task in allTasks {
    var saveDictionary = dictionary(fromTask: task as! Tasks)
    print("saving normal")
    saveArray.append(saveDictionary )
}

for task in completedTasks {
    print("saving completed")
    var saveDictionary = dictionary(fromTask: task as! Tasks)

    saveCompletedArray.append(saveDictionary)
}

for task in overdueTasks {
    var saveDictionary = dictionary(fromTask: task as! Tasks)
    print("saving overdue")

    saveOverdueArray.append(saveDictionary )
}

userDefaults.set(saveArray, forKey: ARRAY_OF_DICTIONARIES)
userDefaults.set(saveCompletedArray, forKey: COMPLETED_TASKS)
userDefaults.set(saveOverdueArray, forKey: OVERDUE_TASKS)

userDefaults.synchronize()

}

func didAddTask(task: Tasks?) {
    if isOverdue(task!.dueDate) {
        overdueTasks.append(task!)
    } else {
        allTasks.append(task!)
    }
    saveTasks()
    tableView.reloadData()
    dismiss(animated: true)
}
    
func isOverdue(_ dueDate: Date?) -> Bool {
    today = Date()

    let intToday = Int(today.timeIntervalSince1970)
    let intDueDate = Int(dueDate?.timeIntervalSince1970 ?? 0)

    if intDueDate < intToday {
        return true
    } else {
        return false
    }
}
    
func didCancel() {
    dismiss(animated: true)
}
func didSaveTask(task: Tasks?, at indexPath: IndexPath) {
    if indexPath.section == 0 {
        allTasks.remove(at: indexPath.row)
        completedTasks.append(task!)
    } else if indexPath.section == 1 {
        overdueTasks.remove(at: indexPath.row)
        completedTasks.append(task!)
    } else {
        completedTasks.remove(at: indexPath.row)
        if isOverdue(task?.dueDate) {
            overdueTasks.append(task!)
        } else {
            allTasks.append(task!)
        }
    }


    saveTasks()
    loadTasks()
    tableView.reloadData()
    
    }

}

