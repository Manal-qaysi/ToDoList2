
import Foundation
import CoreData

class DataManager: ObservableObject{
    let container = NSPersistentContainer(name: "DataModel")
    init(){
        container.loadPersistentStores{ desc, error in if let error = error  {
            print("Filed to load the datd \(error.localizedDescription)")
            
            
            
            
            
        }
        }
        
        
        
        
    }
}
