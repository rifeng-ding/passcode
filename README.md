# Passcode
A simple project for passcode gating.

## Basic AC

1. On the first launch you should land on settings page with a toggle control to activate/deactivate passcode secure mode. When user switches the control on, a “New Passcode" view should pop-up. User enters new passcode and then he should confirm it into another view. If 2 passcode don’t coincide - error alert. On success - passcode screen should dismiss and user should see “Settings” view with a switch control toggled on. 
2. “Settings” view page should be the main (root) view of the app. All other screens should appear modally above it.
3. With activated “secured” mode (passcode is setup): 
- If user puts application into background and then brings it back to foreground, he should land on “Enter Passcode” screen, which should be presented as a modal window above.
- If entered passcode is incorrect: show error message. After 3 failed attempts - app should be locked for 1 minute and display a corresponding message for user. If user “kills” the app when it was locked for a minute and launches it again, the app should stay locked until timeout.
- If entered passcode is correct: dismiss “Enter passcode” screen and the user should see “Settings” view.
- If user “kills” the app and launches it again: he should land on “Enter Passcode” screen (same as return back to foreground) and the main view (“Settings” view) should be blocked for him until he enters correct passcode.
4. With deactivated “secured” mode (passcode is not setup and the switch control on “Settings” page was toggled off):
-  User always land on “Settings” page when he launches the app or if he brings it back to foreground .

### Other Assumptions:
* There's no length limit for the passcode, as long as it's not empty.

## Discussions:

### Unit Test:
The logic part of the project (i.e. the `Passcode` model, `KeyChainUtility` and `PasscodeUtility`) were finished first before being used by any view models. Thus, when they were finished, corresponding unit tests were implemented for validating their correctness.

The test coverages for those files that contain "core" logic of this project are:
| File Name | Unit Test Coverage |
| --- | --- |
| Passcode.swift | 100% |
| PasscodeUtility.Swift | 94.5% |
| KeychainUtility.Swift | 78.9% |

\* To save time, `KeychainUtility` is only tested through `PasscodeUtility`. This is done on purpose.

The missing percentage is mainly code that covers Keychain API exceptions or for completeness of the functionality (e.g. `removeValue(for:` method on `KeychainUtility` is not used/tested in the project, but it should be there).

Since the "core" logic is well unit-tested, for simplicity, view models in the project are not unit-tested. However, they are all done with unit-test-ablity in mind.

### Reusability:
Technically, all files inside the `Models` and `Utilities` folders can be separated into a stand-alone framework/Swift package for better reusability (also their corresponding unit tests). For simplicity, they are all kept in this project. However, proper accessibility specifiers are still used (`internal` vs `public`).
