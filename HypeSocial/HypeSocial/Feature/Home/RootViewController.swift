//
// Created by Douglas Mendes on 2018-12-12.
// Copyright (c) 2018 Douglas Mendes. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class RootViewController: UIViewController, NVActivityIndicatorViewable {

    private let tempServiceMSAL = TempServiceMSAL.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .blue
        let activityData = ActivityData(message: "Get Info from Outlook", type: .ballScaleRippleMultiple)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        tempServiceMSAL.start()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Searching user...")
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
            NVActivityIndicatorPresenter.sharedInstance.setMessage("User not logged in")
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
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Get user Events")
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            let eventListViewController = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: String(describing: EventListViewController.self))
            let eventListNavViewController = UINavigationController(rootViewController: eventListViewController)
            self.present(eventListNavViewController, animated: true)
            self.dismissLoading()
        }
    }

    private func dismissLoading() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        tempServiceMSAL.currentAccount()
    }
}
