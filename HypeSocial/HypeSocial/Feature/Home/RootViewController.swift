//
// Created by Douglas Mendes on 2018-12-12.
// Copyright (c) 2018 Douglas Mendes. All rights reserved.
//

import UIKit

final class RootViewController: UIActivityIndicatorViewController {

    private let tempServiceMSAL = TempServiceMSAL.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .levioGreen
        showLoading(withMessage: Strings.Root.getInfoFromOutlook)
        tempServiceMSAL.start()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.update(loadingMessage: Strings.Root.searchUser)
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            if self.tempServiceMSAL.isLoggedIn {
                self.gotoEventList()
            } else {
                self.gotoLogin()
            }
        }
    }

    private func gotoLogin() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.update(loadingMessage: Strings.Root.userNotLoggedIn)
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            let homeViewController = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: String(describing: HomeViewController.self))
            let navViewController = UINavigationController(rootViewController: homeViewController)
            self.present(navViewController, animated: true)
            self.dismissLoading()
        }
    }

    private func gotoEventList() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.update(loadingMessage: Strings.Root.getUserEventsList)
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            let eventListViewController = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: String(describing: EventListViewController.self))
            let eventListNavViewController = UINavigationController(rootViewController: eventListViewController)
            self.present(eventListNavViewController, animated: true)
            self.tempServiceMSAL.currentAccount()
            self.dismissLoading()
        }
    }
}
