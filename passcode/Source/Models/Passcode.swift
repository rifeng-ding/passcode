//
//  Passcode.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import Foundation

public struct Passcode: Codable {

    public static let retryLimit = 3
    public static let retryDelayInSeconds: TimeInterval = 60

    public let value: String

    public private(set) var retryCount = 0
    public private(set) var unlockDate: Date?

    public init(value: String) {

        self.value = value
    }

    public mutating func validateAgainst(_ inputPasscode: String) -> Bool {

        guard self.value == inputPasscode else {

            self.retryCount = min(Self.retryLimit, self.retryCount + 1)
            if self.retryCount == Self.retryLimit {
                self.unlockDate = Date().addingTimeInterval(Self.retryDelayInSeconds)
            }
            return false
        }

        self.resetRetry()
        return true
    }

    public mutating func resetRetry() {

        self.retryCount = 0
        self.unlockDate = nil
    }
}
