//
//  PasscodeError.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import Foundation

public enum PasscodeError: Error {

    case updateFailed
    case readFailed
    case notSetup
    case validationFailed(remainingRetries: Int)
    case tooManyRetries(unlockDate: Date)
}

extension PasscodeError: LocalizedError {

    public var errorDescription: String? {

        switch self {

        case .updateFailed:
            return NSLocalizedString("Cannot update passcode at the moment.", comment: "")

        case .readFailed:
            return NSLocalizedString("Cannot read passcode at the moment.", comment: "")

        case .notSetup:
            return NSLocalizedString("No passcode has been setup yet.", comment: "")

        case .validationFailed(let remainingRetries):
             return NSLocalizedString("Wrong passcode. Remaining retry time(s): \(remainingRetries)", comment: "")
            
        case .tooManyRetries(let unlockDate):
            return NSLocalizedString("Wrong passcode. Retry is locked until \(unlockDate).", comment: "")
        }
    }
}
