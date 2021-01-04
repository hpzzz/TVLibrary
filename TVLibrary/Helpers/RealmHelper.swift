//
//  RealmHelper.swift
//  TVLibrary
//
//  Created by Karol Harasim on 04/01/2021.
//  Copyright © 2021 Karol Harasim. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    static func saveObject<T:Object>(object: T) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    static func getObjects<T:Object>()->[T] {
        let realm = try! Realm()
        let realmResults = realm.objects(T.self)
        return Array(realmResults)

    }
    static func getObjects<T:Object>(filter:String)->[T] {
        let realm = try! Realm()
        let realmResults = realm.objects(T.self).filter(filter)
        return Array(realmResults)

    }
}
