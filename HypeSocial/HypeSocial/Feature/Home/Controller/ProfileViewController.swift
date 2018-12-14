//
// Created by Douglas Mendes on 2018-12-12.
// Copyright (c) 2018 Douglas Mendes. All rights reserved.
//

import UIKit
import SafariServices

final class ProfileViewController: UIViewController {

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var signOutButton: UIButton!

    let tempServiceMSAL = TempServiceMSAL.instance

    var safariViewControllerDelegate: (() -> Void)? = nil

    private var profileImage: UIImage?
    private var nameString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setupSingOutButton()
    }

    private func setupSingOutButton() {
        signOutButton.addTarget(self, action: #selector(signoutCurrentAccount), for: .touchUpInside)
    }

    private func setupImageView() {
        profileImageView.layer.borderColor = UIColor.levioGreen.cgColor
        profileImageView.layer.borderWidth = 16
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = false
        profileImageView.layer.shadowColor = UIColor.black.cgColor
        profileImageView.layer.shadowOffset = CGSize(width: 0, height: 5)
        profileImageView.layer.shadowOpacity = 0.3
        profileImageView.backgroundColor = .white

        profileImageView.image = profileImage
        nameLabel.text = nameString
    }

    func update(userName: String, andUserImage image: UIImage) {
        profileImage = image
        nameString = userName
    }


    @objc func signoutCurrentAccount() {
        tempServiceMSAL.signout()
        let urlString = "https://login.microsoftonline.com/common/oauth2/v2.0/logout"
        var logoutUrl = URL(string: urlString)!
        var components = URLComponents(url: logoutUrl, resolvingAgainstBaseURL: false)!
        var queryItem = URLQueryItem(name: "post_logout_redirect_uri", value: "http://bitwise.ltda/")

        components.queryItems = [queryItem]

        let safariViewController = SFSafariViewController(url: components.url!)

        safariViewController.delegate = self

        self.present(safariViewController, animated: true)
    }
}

extension ProfileViewController: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        let homeViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: String(describing: HomeViewController.self))
        let navViewController = UINavigationController(rootViewController: homeViewController)
        self.present(navViewController, animated: true)
    }
}
