import SwiftUI

struct AddTaskView: View {
    @Environment(\.managedObjectContext)  var viewContext
    @Environment(\.dismiss) var dismiss
    @State var taskname: String = ""
    @State var taskDetails: String = ""
    @State var dueDate: Date = .init()
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $taskname)
                    TextField("Write details", text: $taskDetails)
                    DatePicker(selection: $dueDate) {
                        Text("Due date")
                    }
                } header: {
                    Text("Add title")
                } footer: {
                    Text("You can add a title to your task to prioritize your goal.")
                }
                
                Button {
                    if taskname.isEmpty{
                        print("Name is empty")
                    }
                    
                    else{
                        
                        
                        addItem()
                      
                        dismiss()}
                } label: {
                    Text("Add Task")
                    
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(.borderless)
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.large)
        }
        
    }
    
    func addItem() {
        withAnimation {
            let newItem = TaskEntities(context: viewContext)
            newItem.id = UUID()
            newItem.dueDate = dueDate
            newItem.isDone = false
            newItem.name = taskname.isEmpty ? "Unnamed Task" : taskname // Fallback if name is empty
            newItem.details = taskDetails
            newItem.createddate = Date()
            do {
                try viewContext.save()
            } catch {
                // Handle the Core Data save error
                print("Error saving task: \(error.localizedDescription)")
            }
        }
    }
}
