//
//  PasscodeUtility.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import Foundation

public final class PasscodeUtility {

    /// The date that is going to be used to test against passcode's unlockDate.
    ///
    /// For depdenency injection during unit tests.
    static var _testCurrentDate: Date?

    private static let keychainUtility = KeychainUtility(secureStoreQueryable: PasscodeQuery())

    //MARK - Internal Methods

    static func currentPasscode() throws -> Passcode? {

        do {
            return try self.keychainUtility.getValue(for: PasscodeQuery.keychainAccount,
                                                     type: Passcode.self)
        } catch {
            throw PasscodeError.readFailed
        }
    }

    static func saveToKeychain(_ passcode: Passcode) throws {

        do {
            try self.keychainUtility.set(passcode, for: PasscodeQuery.keychainAccount)
        } catch  {
            throw PasscodeError.updateFailed
        }
    }

    //MARK - Public Methods

    public static var isPasscodeSetup: Bool {

        return (try? self.currentPasscode()) != nil
    }

    public static func updatePasscode(_ newPasscode: String) throws {

        try self.saveToKeychain(Passcode(value: newPasscode))
    }

    public static func validate(_ inputPasscode: String) throws {

        do {
            guard var currentPasscode = try self.currentPasscode() else {
                throw PasscodeError.notSetup
            }

            defer {
                try? self.saveToKeychain(currentPasscode)
            }

            if let unlockDate = currentPasscode.unlockDate {

                // Didn't create TEST build configuration
                #if DEBUG
                let currentDate = self._testCurrentDate ?? Date()
                #else
                let currentDate = Date()
                #endif

                if currentDate < unlockDate {
                    throw PasscodeError.tooManyRetries(unlockDate: unlockDate)
                } else {
                    currentPasscode.resetRetry()
                }
            }

            guard currentPasscode.validateAgainst(inputPasscode) else {
                if let unlockDate = currentPasscode.unlockDate {
                    throw PasscodeError.tooManyRetries(unlockDate: unlockDate)
                }
                throw PasscodeError.validationFailed(remainingRetries: Passcode.retryLimit - currentPasscode.retryCount)
            }

        } catch {
            throw error
        }
    }

    public static func disablePasscode() {

        try? self.keychainUtility.removeAllValues()
        self._testCurrentDate = nil
    }
}
