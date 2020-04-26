//
//  KeychainQueryable.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import Foundation

public protocol KeychainQueryable {

    var query: [String: Any] { get }
}
