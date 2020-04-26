//
//  PasscodeQuery.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import Foundation

struct PasscodeQuery: KeychainQueryable {

    static let keychainAccount = "com.passcode.passcodeQuery"

    var query: [String: Any] {
        
        return [
            String(kSecClass): kSecClassGenericPassword
        ]
    }
}
