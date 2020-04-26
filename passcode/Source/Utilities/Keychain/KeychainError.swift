//
//  KeychainError.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import Foundation

public enum KeychainError: Error {
    case objectEncodingFailure
    case valueDecodingFailure
    case unhandledError(message: String)

    init(from status:OSStatus) {
        let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        self = .unhandledError(message: message)
    }
}

extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .objectEncodingFailure:
            return NSLocalizedString("Object encoding failed", comment: "")
        case .valueDecodingFailure:
            return NSLocalizedString("Keychain value decoding failed", comment: "")
        case .unhandledError(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
