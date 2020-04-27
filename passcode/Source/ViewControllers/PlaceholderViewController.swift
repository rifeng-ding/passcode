//
//  PlaceholderViewController.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-27.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import UIKit

class PlaceholderViewController: BaseViewController {

    override func setupUI() {
        self.title = "Some View Controller"

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is a placeholder view controller"
        self.view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTouchUpInside))
    }

    @objc private func cancelButtonTouchUpInside() {

        self.dismiss(animated: true, completion: nil)
    }
}
