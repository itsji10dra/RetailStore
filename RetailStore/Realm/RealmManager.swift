//
//  RealmManager.swift
//  RetailStore
//
//  Created by Jitendra on 12/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import RealmSwift

class RealmManager {
    
    public static let shared = RealmManager()
    
    private let realm = try! Realm()

    // MARK: - Initializer
    
    private init() { } 

    // MARK: - Public
    
    public func printRealmPath() {
        print(Realm.Configuration.defaultConfiguration.fileURL?.path ?? "N/A")
    }

    public func getAllObjects<T: Object>(_ type: T.Type) -> [T] {
        let result = realm.objects(type)
        let data: [T] = (0..<result.count).map { index in return result[index] }
        return data
    }

    public func saveObject<T: Object>(data: [T]) {
        try! realm.write {
            realm.add(data, update: .all)
        }
    }
    
    public func deleteObject<T: Object>(type: T.Type, primaryKey: Any) {
        guard let object = realm.object(ofType: type, forPrimaryKey: primaryKey) else { return }
        try! realm.write {
            realm.delete(object)
        }
    }
    
    public func deleteAllObjects() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
