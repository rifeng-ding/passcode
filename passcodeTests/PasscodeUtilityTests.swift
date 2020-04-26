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
            XCTFail("Set Passcode failed with \(error.localizedDescription).")
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
            XCTFail("Set Passcode failed with \(error.localizedDescription).")
        }
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
