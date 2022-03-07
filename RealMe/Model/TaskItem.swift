//
//  TaskItem.swift
//  RealMe
//
//  Created by shehan karunarathna on 2022-03-07.
//

import Foundation
import SwiftUI
import RealmSwift

class TaskItem:Object, Identifiable{
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var taskTitle: String
    @Persisted var taskDate: Date = Date()
    @Persisted var taskStatus: TaskStats = .pending
    
}


enum TaskStats : String, PersistableEnum{
    case missed = "Missed"
    case completed = "Completed"
    case pending = "Pending"
}
