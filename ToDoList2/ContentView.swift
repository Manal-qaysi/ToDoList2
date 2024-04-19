
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskEntities.dueDate, ascending: true)],
        animation: .default)
    
    
    private var taskEntities: FetchedResults<TaskEntities>
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter}()
    
    @State private var showingAddview = false
    @State private var isEditing = false
    
    
    
    
    
    @State private var sortOption: SortOption = .dueDate //sort var
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                List {
                    ForEach(sortedTasks(), id:\.id) { task in
                        if isEditing || task.isDone {
                            HStack {
                                Button {
                                    withAnimation {
                                        task.isDone.toggle()
                                        
                                        if viewContext.hasChanges {
                                            do {
                                                try viewContext.save()
                                                
                                            } catch {
                                                let nsError = error as NSError
                                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                            }
                                        }
                                    }
                                } label: {
                                    if task.isDone {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title)
                                            .foregroundStyle(.green)
                                    } else {
                                        Image(systemName: "circle")
                                            .font(.title)
                                            .foregroundStyle(.black)
                                    }
                                    
                                }
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(task.name ?? "")
                                        .strikethrough(task.isDone, color: .black)
                                    
                                    Text(task.details ?? "")
                                        .bold()
                                        .strikethrough(task.isDone, color: .black)
                                    if let date = task.dueDate {
                                        Text(date.formatted())
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .strikethrough(task.isDone, color: .black)
                                    }
                                }
                                
                                Spacer()
                            }
                        } else {
                            NavigationLink(destination: EditTaskView(task: task)) {
                                HStack {
                                    if task.isDone {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title)
                                            .foregroundStyle(.green)
                                    } else {
                                        Image(systemName: "circle")
                                            .font(.title)
                                            .foregroundStyle(.black)
                                    }
                                    
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(task.name ?? "")
                                        Text(task.details ?? "")
                                            .bold()
                                        if let date = task.dueDate {
                                            Text(date.formatted())
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()
                                    
                                }
                                
                            }
                        }
                        
                        
                    }
                    .onDelete(perform: deleteItems)
                }
                
            }
            .navigationTitle("To Do List")
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            sortOption = .dueDate
                        }){Label("Sort by Due Date",systemImage:"calendar.circle")
                            
                        }
                        Button(action: {
                            sortOption = .completion
                        }){Label("Sort by Completion",systemImage:"checkmark.circle")
                            
                        }
                    } label: {
                        Label("Sort", systemImage: "line.horizontal.3.circle")
                    }
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                        showingAddview.toggle()
                        
                    }) {
                        Label("Add Task", systemImage: "plus.circle")
                        
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditing ? "Done" : "Edit") {
                        withAnimation {
                            isEditing.toggle()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddview) {
                AddTaskView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
        .navigationViewStyle(.stack)
        
    }
    
    private func sortedTasks() -> [TaskEntities] {
        switch sortOption {
        case .dueDate:
            return taskEntities.sorted { ($0.dueDate ?? Date.distantFuture) < ($1.dueDate ?? Date.distantFuture) }
        case .completion:
            return taskEntities.sorted { $0.isDone && !$1.isDone }
        }
    }
    
    enum SortOption {
        case dueDate
        case completion
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { taskEntities[$0] }.forEach { taskEntity in
                viewContext.delete(taskEntity)
            }
            
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
                
                
                
                
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
