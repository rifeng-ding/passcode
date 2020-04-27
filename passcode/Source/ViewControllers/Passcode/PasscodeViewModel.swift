//
//  PasscodeViewModel.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import Foundation

public enum PasscodeViewModelError: Error {

    case confirmationNotMatch
}

extension PasscodeViewModelError: LocalizedError {

    public var errorDescription: String? {

        switch self {

        case .confirmationNotMatch:
            return NSLocalizedString("The confirmation doesn't match to the passcode input in previous step.", comment: "")
        }
    }
}

class PasscodeViewModel {

    enum Mode {
        case setup(isConfirmed: Bool)
        case validation

    }

    private(set) var mode: Mode
    private(set) var unconfirmedPasscode: String?

    private lazy var dateFormatter: DateFormatter = {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dataFormatter
    }()

    var isSetupMode: Bool {

        if case .setup(_) = self.mode {
            return true
        }
        return false
    }

    var title: String? {

        switch self.mode {
        case .setup(_):
            return self.unconfirmedPasscode == nil ? "New Passcode" : "Confirm Passcode"
        case .validation:
            return "Enter Passcode"
        }
    }

    var placeholder: String {

        switch self.mode {
        case .setup(_):
            return self.unconfirmedPasscode == nil ? "Enter a passcode of your choice" : "Re-enter the same passcode"
        case .validation:
            return "Passcode"
        }
    }

    init(mode: Mode) {

        self.mode = mode
    }

    func processPasscode(_ passcode: String) -> Result<Void, Error> {

        switch mode {

        case .setup(_):

            guard let unconfiredPasscode = self.unconfirmedPasscode else {
                self.unconfirmedPasscode = passcode
                return .success(())
            }

            guard unconfiredPasscode == passcode else{
                return .failure(PasscodeViewModelError.confirmationNotMatch)
            }

            self.mode = .setup(isConfirmed: true)
            do {
                try PasscodeUtility.updatePasscode(passcode)
                return .success(())
            } catch {
                return .failure(error)
            }

        case .validation:
            do {
                try PasscodeUtility.validate(passcode)
                return .success(())
            } catch {
                return .failure(error)
            }
        }
    }

    func formatUnlockDate(_ unlockDate: Date) -> String {

        return self.dateFormatter.string(from: unlockDate)
    }
}
