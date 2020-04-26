//
//  PasscodeQuery.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import Foundation

struct PasscodeQuery: KeychainQueryable {

    enum KeychainAccount {

        static let passcodeValue = "PasscodeQuery.passcode_value"
        static let retryCount = "PasscodeQuery.retry_count"
        static let unlockDate = "PasscodeQuery.unlock_date"
    }

    var query: [String: Any] {
        
        return [
            String(kSecClass): kSecClassGenericPassword
        ]
    }
}
