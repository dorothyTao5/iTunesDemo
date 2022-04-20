//
//  UserDefaultsExtension.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/20.
//

import Foundation


protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsSettable where defaultKeys.RawValue == String {
    static func set(value: Any?, forKey key: defaultKeys) {
        let key = key.rawValue
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    static func set<T: Codable>(object: T, forKey key: defaultKeys) {
        let key = key.rawValue
        let data = try? JSONEncoder().encode(object)
        UserDefaults.standard.set(data, forKey: key)
    }

    static func bool(forKey key: defaultKeys) -> Bool {
        let key = key.rawValue
        return UserDefaults.standard.bool(forKey: key)
    }

    static func string(forKey key: defaultKeys) -> String {
        let key = key.rawValue
        return UserDefaults.standard.string(forKey: key) ?? ""
    }

    static func integer(forKey key: defaultKeys) -> Int {
        let key = key.rawValue
        return UserDefaults.standard.integer(forKey: key)
    }

    static func remove(forKey key: defaultKeys) {
        let key = key.rawValue
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func object<T: Codable>(_ type: T.Type, with key: defaultKeys) -> T? {
        let key = key.rawValue
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    static func object<T>(type: T.Type, with key: defaultKeys) -> T? {
        let key = key.rawValue
        if let object = UserDefaults.standard.object(forKey: key) as? T {
            return object
        } else {
            return nil
        }
    }
}
