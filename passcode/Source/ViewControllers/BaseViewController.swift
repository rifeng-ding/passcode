//
//  BaseViewController.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        self.setupUI()

        self.view.backgroundColor = UIColor.systemBackground
    }

    func setupUI() {
        // should be overriden by subclass to setup UI elements
    }
}
