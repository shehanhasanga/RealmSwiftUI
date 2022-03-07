//
//  Home.swift
//  RealMe
//
//  Created by shehan karunarathna on 2022-03-07.
//

import SwiftUI
import RealmSwift

struct Home: View {
    
    @ObservedResults(TaskItem.self, sortDescriptor: SortDescriptor.init(keyPath: "taskDate",ascending: false)) var tasks
    @State var lastAddedId:String = ""
    var body: some View {
        NavigationView{
            ZStack{
                if tasks.isEmpty {
                    Text("add new tasks")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    List{
                        ForEach(tasks) { task in
                            TaskRow(task: task, lastAddedItem: $lastAddedId)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role:.destructive){
                                        DispatchQueue.main.async {
                                            $tasks.remove(task)
                                        }
                                       
                                    }label: {
                                        Image(systemName: "trash")
                                    }
                                }
                        }
                    }
                    .animation(.easeInOut, value: tasks)
                }
            }
          
            .navigationTitle("Task's")
            .toolbar {
                Button{
                   let task  =  TaskItem()
                    lastAddedId = task.id.stringValue
                    $tasks.append(task)
                }label: {
                    Image(systemName: "plus")
                }
            }
            .onReceive(NotificationCenter.default.publisher(for:UIResponder.keyboardWillHideNotification )) { _ in
                lastAddedId = ""
                guard let last = tasks.last else {
                    return
                }
                if last.taskTitle == "" {
//                    $tasks.remove(last)
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct TaskRow: View {
    @ObservedRealmObject var task: TaskItem
    @Binding var lastAddedItem : String
    @FocusState var showKeyboard : Bool
    var body: some View{
        HStack(spacing:10){
            Menu {
                Button("Missed"){
                    $task.taskStatus.wrappedValue = .missed
                }
                
                Button("Completed"){
                    $task.taskStatus.wrappedValue = .completed
                }
            }label: {
                Circle()
                    .stroke(.gray)
                    .frame(width: 15, height: 15)
                    .overlay(
                        Circle().fill(task.taskStatus == .missed ? .red : (task.taskStatus == .pending ? .yellow : .green ))
                    )
            }
            
            VStack(alignment: .leading, spacing: 10){
                TextField("Add new Item", text: $task.taskTitle)
                    .focused($showKeyboard)
                
                if task.taskTitle != "" {
                    Picker(selection: .constant("")) {
                        DatePicker( selection: $task.taskDate, displayedComponents: .date){
                            
                        }
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .navigationTitle("Task Date")
                    }label: {
                        HStack{
                            Image(systemName: "calendar")
                            Text(task.taskDate.formatted(date: .abbreviated, time: .omitted))
                        }
                    }

                }
            }
        }
        .padding(.trailing, 20)
        .onAppear {
            if lastAddedItem == task.id.stringValue{
                showKeyboard.toggle()
            }
        }
    }
}
