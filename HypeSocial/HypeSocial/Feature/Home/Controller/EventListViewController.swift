//
// Created by Douglas Mendes on 2018-12-09.
// Copyright (c) 2018 Douglas Mendes. All rights reserved.
//

import UIKit
import Cards
import SnapKit

extension EventListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

final class EventListDataSource: NSObject, UITableViewDataSource {

    unowned var tempViewController: EventListViewController

    init(tempViewController: EventListViewController) {
        self.tempViewController = tempViewController
    }


    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeCell = tableView.dequeueReusableCell(withIdentifier: HomeViewCell.identifier) as! HomeViewCell
        homeCell.bindTo(viewModel: tempViewController.mock)
        return homeCell
    }
}

extension EventListViewController: CardDelegate {
    public func cardDidTapInside(card: Card) {
        let eventDetailViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: String(describing: EventDetailViewController.self))
        let navViewController = UINavigationController(rootViewController: eventDetailViewController)

        navViewController.navigationBar.topItem?.title = "About US Event"
        navViewController.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closeViewController))
        self.present(navViewController, animated: true)
    }
}

final class EventListViewController: UIViewController {
    private let tableView = UITableView()
    private var homeDataSource: EventListDataSource!

    var mock: HomeCardViewModel {
        let eventDetailViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: String(describing: EventDetailViewController.self))

        return HomeCardViewModel(
                backgroundColor: .levioGreen,
                icon: UIImage(named: "event-icon")!,
                title: "Welcome \nto \nLevio Events !",
                itemTitle: "Noel Party",
                itemSubtitle: "This will be a great event =)",
                textColor: .white,
                hasParallax: false,
                eventDetailViewController: eventDetailViewController,
                fromViewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeDataSource = EventListDataSource(tempViewController: self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.width.height.equalToSuperview()
        }

        tableView.register(HomeViewCell.self, forCellReuseIdentifier: HomeViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = homeDataSource

        setupNavigationBar()
    }


    private func setupNavigationBar() {
        guard let navigationController = navigationController else { return }
        let userImage = UIImage(named: "user-filled")!.withRenderingMode(.alwaysTemplate)
        let userImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        userImageView.contentMode = .scaleAspectFill
        userImageView.image = userImage

        let userButtonItem = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        userButtonItem.setBackgroundImage(userImage, for: .normal)
        userButtonItem.tintColor = .levioGreen
        userButtonItem.snp.makeConstraints { maker in
            maker.width.height.equalTo(30)
        }

        userButtonItem.addTarget(self, action: #selector(didTapProfileBarButton), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: userButtonItem)
        navigationItem.title = "Levio Events"
    }

    @objc func didTapProfileBarButton() {
        let tempService = TempServiceMSAL.instance
        let profileViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as! ProfileViewController

        profileViewController.update(userName: tempService.currentAccount()!.username!,
                andUserImage: UIImage(named: "user-filled")!)

        let navViewController = UINavigationController(rootViewController: profileViewController)
        navViewController.navigationBar.topItem?.title = "Account"
        navViewController.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closeViewController))
        self.present(navViewController, animated: true)
    }

    @objc func closeViewController() {
       dismiss(animated: true)
    }

}
