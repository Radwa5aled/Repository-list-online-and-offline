


import Foundation
import CoreData
import UIKit

//CoreData Singleton
class CoreDataManager {
    
    //1
    static let sharedManager = CoreDataManager()
    //2.
    private init() {} // Prevent clients from creating another instance.

    //3
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "JakeWhartonRepos")
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    //4
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //----------------------------------------------------------------------
     //Colors Operations
    func saveRepos(repo: ReposModel ){
        
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Repositories", in: managedContext)!
       
        let repos = NSManagedObject(entity: entity, insertInto: managedContext)
        
        if idExists(id: repo.id, managedObject:managedContext) == false {
        
            repos.setValue(repo.id, forKeyPath: "id")
            repos.setValue(repo.name, forKeyPath: "name")
            repos.setValue(repo.repoDescription, forKeyPath: "repoDescription")
            repos.setValue(repo.language, forKeyPath: "language")
            repos.setValue(repo.forks, forKeyPath: "forks")
            repos.setValue(repo.watchers, forKeyPath: "watchers")
            repos.setValue(repo.pushedAt, forKeyPath: "pushedAt")
            repos.setValue(repo.archived, forKeyPath: "archived")
            if let license = repo.license {
                repos.setValue(license.name, forKeyPath: "licenseName")
            }
            
            do {
                
                try managedContext.save()
                print("😁😁😁😁😁😁 saved")
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }else {
             print("😁😁😁😁😁😁 already exist")
        }
        
       
    }
    

    func fetchAllRepos(completion:@escaping (_ repos:[Repositories]?)->Void){
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Repositories")
        
        
        do
        {
            
            let fetchResult = try managedContext.fetch(fetchRequest)
            
            completion(fetchResult as? [Repositories])
            
            
        }
        catch
        {
            print(error)
            completion(nil)
        }
        
    }
    
    func idExists(id: Int, managedObject:NSManagedObjectContext) -> Bool {
        
        //let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Repositories")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try managedObject.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    func deleteAllRepos(completion:@escaping (_ textStr:String?)->Void){
        
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Repositories")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            
            completion("done successfully")
            
        } catch {
            // Do something in response to error condition
            print(error)
        }
        
    }
    

    
    
}
