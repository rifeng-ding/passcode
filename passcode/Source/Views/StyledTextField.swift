//
//  StyledTextField.swift
//  silofit
//
//  Created by Rifeng Ding on 2020-04-23.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import UIKit

class StyledTextField: UITextField {

    static let defaultHeight: CGFloat = 60
    static let inset: CGFloat = 20

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.secondarySystemBackground
        self.layer.borderColor = UIColor.separator.cgColor
        self.layer.cornerRadius = 1

        self.heightAnchor.constraint(equalToConstant: Self.defaultHeight).isActive = true
    }

    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Self.inset, dy: 0)
    }

    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Self.inset , dy: 0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Self.inset, dy: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
