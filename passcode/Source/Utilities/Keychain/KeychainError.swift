//
//  KeychainError.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import Foundation

public enum KeychainError: Error {
    case string2DataConversionError
    case data2StringConversionError
    case unhandledError(message: String)

    init(from status:OSStatus) {
        let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        self = .unhandledError(message: message)
    }
}

extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .string2DataConversionError:
            return NSLocalizedString("String to Data conversion error", comment: "")
        case .data2StringConversionError:
            return NSLocalizedString("Data to String conversion error", comment: "")
        case .unhandledError(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
