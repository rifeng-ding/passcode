//
//  SettingsViewModel.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import UIKit

class SettingsViewModel {

    var title: String? {
        return "Settings"
    }

    var isPasscodeEnabled: Bool {

        return PasscodeUtility.isPasscodeSetup
    }

    func disablePasscode() {
        
        PasscodeUtility.disablePasscode()
    }
}
