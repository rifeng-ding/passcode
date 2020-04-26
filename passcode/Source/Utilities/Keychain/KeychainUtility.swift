//
//  KeychainUtility.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import Foundation

public class KeychainUtility {

    let secureStoreQueryable: KeychainQueryable

    public init(secureStoreQueryable: KeychainQueryable) {
        self.secureStoreQueryable = secureStoreQueryable
    }

    public func set<T>(_ codableObject: T, for account: String) throws where T: Codable{

        let encoder = JSONEncoder()
        guard let encodedValue = try? encoder.encode(codableObject) else {
            throw KeychainError.objectEncodingFailure

        }

        var query = self.secureStoreQueryable.query
        query[String(kSecAttrAccount)] = account

        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = encodedValue

            status = SecItemUpdate(query as CFDictionary,
                                   attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw KeychainError(from: status)
            }

        case errSecItemNotFound:
            query[String(kSecValueData)] = encodedValue

            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw KeychainError(from: status)
            }
        default:
            throw KeychainError(from: status)
        }
    }


    public func getValue<T>(for account: String, type: T.Type) throws -> T? where T: Codable {

        var query = self.secureStoreQueryable.query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = account

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
            let decoder = JSONDecoder()
            guard
                let queriedItem = queryResult as? [String: Any],
                let data = queriedItem[String(kSecValueData)] as? Data,
                let value = try? decoder.decode(T.self, from: data)
                else {

                    throw KeychainError.valueDecodingFailure
            }

            return value

        case errSecItemNotFound:
            return nil

        default:
            throw KeychainError(from: status)
        }
    }

    public func removeValue(for account: String) throws {

        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = account

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError(from: status)
        }
    }

    public func removeAllValues() throws {

        let query = secureStoreQueryable.query

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError(from: status)
        }
    }
}
