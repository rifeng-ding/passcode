//
//  SettingsViewController.swift
//  passcode
//
//  Created by Rifeng Ding on 2020-04-26.
//  Copyright © 2020 Rifeng Ding. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    let viewModel = SettingsViewModel()
    private(set) var isFirstLaunch = true

    let passcodeSettingLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Passcode"
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    let passcodeSwitch: UISwitch = {

        let passcodeSwitch = UISwitch()
        passcodeSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return passcodeSwitch
    }()

    override func setupUI() {

        let inset:CGFloat = 20

        self.title = self.viewModel.title

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = inset
        self.view.addSubview(stackView)
        // bottom constraint not set
        // based on the assumtion that the stack view is always short enough
        stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                       constant: inset).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                           constant: inset).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                            constant: -inset).isActive = true

        stackView.addArrangedSubview(self.passcodeSettingLabel)
        stackView.addArrangedSubview(self.passcodeSwitch)
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.passcodeSwitch.isOn = self.viewModel.isPasscodeEnabled

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEntreForground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        if self.isFirstLaunch && self.viewModel.isPasscodeEnabled {
            self.isFirstLaunch = false
            self.presentPasscodeViewController(withMode: .validation)
        }
    }

    @objc func switchValueChanged(_ sender: UISwitch) {

        switch sender {
        case self.passcodeSwitch:
            if self.passcodeSwitch.isOn {
                self.presentPasscodeViewController(withMode: .setup(isConfirmed: false))
            } else {
                self.viewModel.disablePasscode()
            }
        default:
            break
        }
    }

    @objc func appDidEntreForground() {

        if self.viewModel.isPasscodeEnabled {
            self.presentPasscodeViewController(withMode: .validation)
        }
    }

    private func presentPasscodeViewController(withMode mode: PasscodeViewModel.Mode) {

        let passcodeViewController = PasscodeViewController(mode: mode)
        passcodeViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: passcodeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension SettingsViewController: PasscodeViewControllerDelegate {

    func didDismissForCreation(creationSucceed: Bool) {

        self.passcodeSwitch.isOn = creationSucceed
    }
}
