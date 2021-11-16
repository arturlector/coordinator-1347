//
//  RealmService.swift
//  swiftui-1347
//
//  Created by Artur Igberdin on 02.11.2021.
//

import Foundation
import RealmSwift

extension Realm.Configuration {
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
}

protocol AnyRealmService {
    func save<T: Object>(items: [T], configuration: Realm.Configuration, update: Realm.UpdatePolicy) throws
    func get<T: Object>(_ type: T.Type, configuration: Realm.Configuration) throws -> Results<T>
    func get<T: Object>(_ type: T.Type, configuration: Realm.Configuration) throws -> [T]
    func delete<T: Object>(object: T, configuration: Realm.Configuration) throws
}

class RealmService: AnyRealmService {
    func save<T: Object>(items: [T], configuration: Realm.Configuration = .deleteIfMigration, update: Realm.UpdatePolicy = .modified
    ) throws {
        let realm = try Realm(configuration: configuration)
        print(configuration.fileURL ?? "")
        try realm.write {
            realm.add(items, update: update)
        }
    }
    
    func get<T: Object>(
        _ type: T.Type,
        configuration: Realm.Configuration = .deleteIfMigration
    ) throws -> Results<T> {
        print(configuration.fileURL ?? "")
        let realm = try Realm(configuration: configuration)
        return realm.objects(type)
    }
    
    func get<T: Object>(
        _ type: T.Type,
        configuration: Realm.Configuration = .deleteIfMigration
    ) throws -> Array<T> {
        print(configuration.fileURL ?? "")
        let realm = try Realm(configuration: configuration)
        
        return realm.objects(type).map { $0.detached() }
    }
    
    func delete<T: Object>(
        object: T,
        configuration: Realm.Configuration = .deleteIfMigration
    ) throws {
        print(configuration.fileURL ?? "")
        let realm = try Realm(configuration: configuration)
        try realm.write {
            realm.delete(object)
        }
    }
}
