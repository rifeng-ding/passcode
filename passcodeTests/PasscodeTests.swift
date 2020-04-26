//
//  PasscodeTests.swift
//  passcodeTests
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import XCTest
@testable import passcode

class PasscodeTests: XCTestCase {

    var passcode: Passcode!
    static let passcodeValue = "1234"
    static let wrongPasscodeValue = "abcd"

    override func setUpWithError() throws {

        self.passcode = Passcode(value: Self.passcodeValue)
    }

    override func tearDownWithError() throws {

    }
    

    func testInit() {

        XCTAssertEqual(self.passcode.value, Self.passcodeValue)
        XCTAssertEqual(passcode.retryCount, 0)
        XCTAssertNil(passcode.unlockDate)
    }

    func testPositiveValidation() {

        XCTAssertTrue(self.passcode.validateAgainst(Self.passcodeValue))
    }

    func testNegativeValidation() {

        for retryNumber in 1 ... Passcode.retryLimit + 1 {

            XCTAssertFalse(self.passcode.validateAgainst(Self.wrongPasscodeValue))

            switch retryNumber {
            case 1 ..< Passcode.retryLimit:
                XCTAssertEqual(passcode.retryCount, retryNumber)
                XCTAssertNil(passcode.unlockDate)
                break
            default:
                XCTAssertEqual(passcode.retryCount, Passcode.retryLimit)
                XCTAssertNotNil(passcode.unlockDate)

                // round up to seconds
                let targetDate = Int(Date().addingTimeInterval(Passcode.retryDelayInSeconds).timeIntervalSince1970)
                let unlockDate = Int(passcode.unlockDate!.timeIntervalSince1970)
                XCTAssertEqual(targetDate, unlockDate)
                break
            }

        }
    }

    func testResetRetry() {

        for _ in 1 ... Passcode.retryLimit + 1 {
            _ = self.passcode.validateAgainst(Self.wrongPasscodeValue)
        }

        XCTAssertEqual(passcode.retryCount, Passcode.retryLimit)
        XCTAssertNotNil(passcode.unlockDate)

        _ = self.passcode.validateAgainst(Self.passcodeValue)
        XCTAssertEqual(passcode.retryCount, 0)
        XCTAssertNil(passcode.unlockDate)
    }
}

