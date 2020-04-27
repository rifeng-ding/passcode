//
//  PasscodeViewController.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import UIKit

protocol PasscodeViewControllerDelegate: class {

    func didDismissForCreation(creationSucceed: Bool)
}

class PasscodeViewController: BaseViewController {

    private(set) var viewModel: PasscodeViewModel
    weak var delegate: PasscodeViewControllerDelegate?

    init(mode: PasscodeViewModel.Mode) {

        self.viewModel = PasscodeViewModel(mode:mode)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let textField: UITextField = {

        let textField = StyledTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        return textField
    }()

    let errorMessageLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.red
        label.numberOfLines = 0
        label.contentMode = .center
        return label
    }()

    override func setupUI() {

        let inset:CGFloat = 20

        self.title = self.viewModel.title

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = inset
        self.view.addSubview(stackView)
        // bottom constraint not set
        // based on the assumption that the stack view is always short enough
        stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                       constant: inset).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                           constant: inset).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                            constant: -inset).isActive = true

        self.textField.delegate = self
        self.textField.placeholder = self.viewModel.placeholder
        stackView.addArrangedSubview(self.textField)

        stackView.addArrangedSubview(self.errorMessageLabel)

        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor.secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.text = "Tap \"done\" on the keyboard when you done entering."
        stackView.addArrangedSubview(messageLabel)

        #if DEBUG
        if !self.viewModel.isSetupMode {
            let hintLabel = UILabel()
            hintLabel.translatesAutoresizingMaskIntoConstraints = false
            hintLabel.textColor = UIColor.tertiaryLabel
            hintLabel.numberOfLines = 0
            hintLabel.text = """
            Current passcode: \((try? PasscodeUtility.currentPasscode())?.value ?? "nil")
            For DEBUG only. Since passcode is stored in keychain, even deleting the app won't remove it.
            """
            stackView.addArrangedSubview(hintLabel)
        }
        #endif

        switch self.viewModel.mode {
        case .setup(_):
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTouchUpInside))
        case .validation:
            if let unlockDate = self.viewModel.unlockDate {
                self.errorMessageLabel.text = self.viewModel.errorMessage(forUnlockDate: unlockDate)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()
    }

    @objc private func cancelButtonTouchUpInside() {

        self.dismiss(animated: true) {
            if self.viewModel.isSetupMode {
                self.delegate?.didDismissForCreation(creationSucceed: false)
            }
        }
    }
}

extension PasscodeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        guard
            textField == self.textField,
            let passcode = textField.text,
            passcode.count > 0
            else {
                return true
        }

        self.textField.resignFirstResponder()

        switch self.viewModel.processPasscode(passcode) {
        case .success:
            self.errorMessageLabel.text = nil
            switch self.viewModel.mode {

            case .validation:
                self.dismiss(animated: true, completion: nil)
            case .setup(let isConfirmed):
                if isConfirmed {
                    self.dismiss(animated: true) {
                        self.delegate?.didDismissForCreation(creationSucceed: true)
                    }
                } else {
                    self.title = self.viewModel.title
                    self.textField.placeholder = self.viewModel.placeholder
                    self.textField.text = nil
                    self.textField.becomeFirstResponder()
                }
            }
        case .failure(let error):

            let errorMessage: String?
            switch error {
            case PasscodeError.tooManyRetries(let unlockDate):
                errorMessage = self.viewModel.errorMessage(forUnlockDate: unlockDate)
            default:
                errorMessage = error.localizedDescription
            }
            self.errorMessageLabel.text = errorMessage
            self.textField.text = nil
        }

        return false
    }
}
