import SwiftUI
import CoreData

struct EditTaskView: View {
    @Environment(\.managedObjectContext)  var viewContext
    @Environment(\.dismiss) var dismiss

    var task: FetchedResults<TaskEntities>.Element


    @State private var dueDate: Date = .init()
    @State private var name: String = ""
    @State private var taskDetails: String = ""



    var body: some View {
        Form {
            TextField("Title", text: $name)
            TextField("Write details", text: $taskDetails)
            DatePicker(selection: $dueDate) {
                Text("Due date")
            }

            // Submit Button
            HStack {
                Spacer()
                Button("Submit") {
                    // Edit task using DataController instance
                    editItem()

                    // Dismiss the view
                    dismiss()
                }
                Spacer()
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            if let safeName = task.name {
                name = safeName
            }

            if let details = task.details {
                taskDetails = details
            }

            if let date = task.dueDate {
                dueDate = date
            }
        }
    }

    func editItem() {
        // Update the item's properties
        task.name = name
        task.dueDate = dueDate
        task.details = taskDetails
        // Save the changes
        try?viewContext.save()
    }
}
