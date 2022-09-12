//
//  RealmModel.swift
//  test
//
//  Created by Darren Hurst on 2021-05-13.
//

import Foundation
import RealmSwift
import Combine



//Combine
class DogInteractor : ObservableObject {
@Published var dogs = [Dog]() // Binding Array
@Published var puppies = [Dog]()
init () {
        self.addBindings()
    }
    func addBindings() {
        let realm: DogRealm = DogRealm.init()
        dogs = realm.getDoggies()  // Combine object Dogs
        puppies = realm.getPuppies()
    }

}

//Realm
protocol DogRealmProtocol {
    func getPuppies() -> [Dog]
    func getDoggies() -> [Dog]
}

struct DogRealm: DogRealmProtocol{
 
    init() {
        startConnection()
    }
    func getPuppies() -> [Dog] {
        let realm = try! Realm()
        return realm.objects(Dog.self).distinct(by: ["name"])
            .filter { (dog) -> Bool in
                dog.age <= 3 }
    }
    func startConnection() -> Void {
        let app = App(id: "socialnanny-gydwt")
        app.login(credentials: Credentials.anonymous) {( response ) in
         
            print("Login status: \(response)") // RLMUser
                  
         
                  let config = Realm.Configuration(
                      // Set the new schema version. This must be greater than the previously used
                      // version (if you've never set a schema version before, the version is 0).
                      schemaVersion: 1,

                      // Set the block which will be called automatically when opening a Realm with
                      // a schema version lower than the one set above
                      migrationBlock: { migration, oldSchemaVersion in
                          // We haven’t migrated anything yet, so oldSchemaVersion == 0
                          if (oldSchemaVersion < 1) {
                              // Nothing to do!
                              // Realm will automatically detect new properties and removed properties
                              // And will update the schema on disk automatically
                          }
                      })

                  // Tell Realm to use this new configuration object for the default Realm
                  Realm.Configuration.defaultConfiguration = config
              
        }
    }
    
    func getDoggies() -> [Dog] {
        let realm = try! Realm()
       // return realm.objects(Dog.self).distinct(by: ["person"]).map{$0}
        
        return realm.objects(Dog.self).distinct(by: ["name"]).map{$0}
    }
    
    func writeNewDog(name: String, age: Int) -> Void {
        let realm = try! Realm()
        let dog = Dog.init()
        dog.name = name
        dog.age = age
    
        try? realm.write {
         realm.add(dog)
        }
    }
    
    func deleteDogs(dogs: [Dog]) -> Void {
        let realm = try! Realm()
        try? realm.write {
         realm.delete(dogs)
        }
    }
    func addDog(dog: Dog) -> Void {
        let realm = try! Realm()
        try? realm.write {
            realm.add(dog)
        }
    }
}

