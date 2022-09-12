//
//  Person.swift
//  test
//
//  Created by Darren Hurst on 2021-05-31.
//
import Foundation
import RealmSwift

class Person: Object, ObjectKeyIdentifiable, Identifiable  {
    //@objc dynamic var id = ObjectId.generate()
    @objc dynamic var name = "Darren"
    @objc dynamic var picture: Data? = nil // optionals supported
   
     dynamic var dogs = RealmSwift.List<Dog>()

}
