//
//  PasscodeUtilityTests.swift
//  passcodeTests
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import XCTest
@testable import passcode

class PasscodeUtilityTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {

        PasscodeUtility.disablePasscode()
    }


    func testNotSetupError() {
        do {
            _ = try PasscodeUtility.validate("some passcode")
            XCTFail("No error is thrown.")
        } catch {
            switch error {
            case PasscodeError.notSetup:
                break
            default:
                XCTFail("Detected wrong error: \(error.localizedDescription).")
            }
        }
    }

    func testSetPasscode() {
        do {
            try PasscodeUtility.updatePasscode("1234")
        } catch {
            XCTFail("Set Passcode failed with \(error.localizedDescription).")
        }
    }

    func testRetrievePasscode() {
        let passcodeValue = "1234"
        do {
            try PasscodeUtility.updatePasscode(passcodeValue)
            let retereivedPasscode = try PasscodeUtility.currentPasscode()
            XCTAssertEqual(retereivedPasscode?.value, passcodeValue)
        } catch {
            XCTFail("Test failed with \(error.localizedDescription).")
        }
    }

    func testUpdatePasscode() {
        let passcodeValue = "1234"
        let newPasscodeValue = "abcd"
        do {
            try PasscodeUtility.updatePasscode(passcodeValue)
            let passcode = try PasscodeUtility.currentPasscode()
            XCTAssertEqual(passcode?.value, passcodeValue)

            try PasscodeUtility.updatePasscode(newPasscodeValue)
            let newPasscode = try PasscodeUtility.currentPasscode()
            XCTAssertEqual(newPasscode?.value, newPasscodeValue)
        } catch {
            XCTFail("Test failed with \(error.localizedDescription).")
        }
    }

    func testPositiveValidation() {
        do {
            let passcodeValue = "1234"
            try PasscodeUtility.updatePasscode(passcodeValue)
            try PasscodeUtility.validate(passcodeValue)
        } catch {
            XCTFail("Test failed with \(error.localizedDescription).")
        }
    }

    func testNegativeThenPosstiveValidationNoLockDown() {

        do {
            let passcodeValue = "1234"
            let wrongPasscodeValue = "abcd"

            try PasscodeUtility.updatePasscode(passcodeValue)
            do {
                try PasscodeUtility.validate(wrongPasscodeValue)
            } catch {
                switch error {
                case PasscodeError.validationFailed(let remainingRetries):
                    XCTAssertEqual(remainingRetries, Passcode.retryLimit - 1)
                default:
                    XCTFail("Detected wrong error: \(error.localizedDescription).")
                }
            }


            try PasscodeUtility.validate(passcodeValue)
        } catch {
            XCTFail("Test failed with \(error.localizedDescription).")
        }
    }


    func testNegativeValidationAndLockDown() {
        do {
            let passcodeValue = "1234"
            let wrongPasscodeValue = "abcd"

            try PasscodeUtility.updatePasscode(passcodeValue)

            for retryNumber in 1 ... Passcode.retryLimit + 1 {

                switch retryNumber {

                case 1 ... Passcode.retryLimit - 1:
                    do {
                        try PasscodeUtility.validate(wrongPasscodeValue)
                    } catch {
                        switch error {
                        case PasscodeError.validationFailed(let remainingRetries):
                            XCTAssertEqual(remainingRetries, Passcode.retryLimit - retryNumber)
                        default:
                            XCTFail("Detected wrong error: \(error.localizedDescription).")
                        }
                    }

                default:
                    do {
                        // when passcode is locked down,
                        // even correct value would end up with .tooManyRetries error
                        let passcodeToTry = retryNumber == Passcode.retryLimit ? wrongPasscodeValue : passcodeValue
                        _ = try PasscodeUtility.validate(passcodeToTry)
                    } catch {
                        switch error {
                        case PasscodeError.tooManyRetries(let unlockDate):

                            // to test the convenient getter for unlockDate
                            XCTAssertEqual(unlockDate, PasscodeUtility.unlockDate)

                            let targetDate = Int(Date().addingTimeInterval(Passcode.retryDelayInSeconds).timeIntervalSince1970)
                            let unlockDate = Int(unlockDate.timeIntervalSince1970)
                            XCTAssertEqual(unlockDate, targetDate)
                            break
                        default:
                            XCTFail("Detected wrong error: \(error.localizedDescription).")
                        }
                    }
                }
            }
        } catch {
            XCTFail("Test failed with \(error.localizedDescription).")
        }
    }

    func testPositiveValidationAfterLockOut() {

        do {
            let passcodeValue = "1234"
            let wrongPasscodeValue = "abcd"

            try PasscodeUtility.updatePasscode(passcodeValue)

            for _ in 1 ..< Passcode.retryLimit {
                // here, try? is used becuase the error here would be covered by test testNegativeValidationAndLockDown
                _ = try? PasscodeUtility.validate(wrongPasscodeValue)
            }

            var targetUnlockDate: Date?
            do {
                _ = try PasscodeUtility.validate(wrongPasscodeValue)
            } catch {
                switch error {
                case PasscodeError.tooManyRetries(let unlockDate):
                    targetUnlockDate = unlockDate
                default:
                    XCTFail("Detected wrong error: \(error.localizedDescription).")
                }
            }

            PasscodeUtility._testCurrentDate = targetUnlockDate
            try PasscodeUtility.validate(passcodeValue)

        } catch {
            XCTFail("Test failed with \(error.localizedDescription).")
        }
    }
}
