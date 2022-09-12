//
//  Dogs.swift
//  test
//
//  Created by Darren Hurst on 2021-05-31.
//
import Foundation
import RealmSwift

class Dog: Object, ObjectKeyIdentifiable, Identifiable   {
   // @objc dynamic var id = ObjectId.generate()
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    
   // override static func primaryKey() -> String? {
   //   "id"
   // }
    /// The backlink to the `Person` this dog is owned by.
    let person = LinkingObjects(fromType: Person.self, property: "dogs")
}
