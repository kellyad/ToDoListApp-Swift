//
//  Tasks.swift
//  SimpleApp
//
//  Created by evhive on 20/03/19.
//  Copyright © 2019 Coco. All rights reserved.
//

import Foundation
class Tasks :NSObject{
//    convenience init() {
//        self.init(title: nil, task: nil, dueDate: nil, isCompleted: nil)
//    }
    var title:String!
    var task:String!
    var dueDate:Date!
    var isCompleted:String!
    
    //designated initializer
    init(title: String?, task: String?, dueDate: Date?, isCompleted: String?) {
        super.init()

        self.title = title
        self.task = task
        self.dueDate = dueDate
        self.isCompleted = isCompleted

    }

    convenience init(dictionary: [AnyHashable : Any]) {
        self.init(title: dictionary["title"] as? String, task: dictionary["task"] as? String, dueDate: dictionary["dueDate"] as? Date, isCompleted: dictionary["isCompleted"] as? String)
    }
}
