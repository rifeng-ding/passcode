//
//  Passcode.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import Foundation

struct Passcode: Codable {

    static let retryLimit = 3
    static let retryDelayInSeconds: TimeInterval = 60

    let value: String

    private(set) var retryCount = 0
    private(set) var unlockDate: Date?

    init(value: String) {

        self.value = value
    }

    mutating func validateAgainst(_ inputPasscode: String) -> Bool {

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

    mutating func resetRetry() {

        self.retryCount = 0
        self.unlockDate = nil
    }
}
