//
// Created by Douglas Mendes on 2018-12-09.
// Copyright (c) 2018 Douglas Mendes. All rights reserved.
//

import UIKit

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
                itemSubtitle: "This will be a great event",
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
    }

}
