//
// Created by Douglas Mendes on 2018-12-04.
// Copyright (c) 2018 Douglas Mendes. All rights reserved.
//

import UIKit
import Cards
import SnapKit

struct HomeCardViewModel {
    let backgroundColor: UIColor
    let icon: UIImage
    let title: String
    let itemTitle: String
    let itemSubtitle: String
    let textColor: UIColor
    let hasParallax: Bool
    let eventDetailViewController: UIViewController
    let fromViewController: UIViewController
}

extension CardHighlight {
    func bindTo(viewModel: HomeCardViewModel) {
        backgroundColor = viewModel.backgroundColor
        icon = viewModel.icon
        title = viewModel.title
        itemTitle = viewModel.itemTitle
        itemSubtitle = viewModel.itemSubtitle
        textColor = viewModel.textColor
        hasParallax = viewModel.hasParallax

        shouldPresent(
                viewModel.eventDetailViewController,
                from: viewModel.fromViewController,
                fullscreen: true)
    }

}

final class HomeViewCell: UITableViewCell {

    private var cardView = CardHighlight(frame: .zero)

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }


    func bindTo(viewModel: HomeCardViewModel) {
        cardView.bindTo(viewModel: viewModel)
    }
}

extension HomeViewCell {
    func createConstraints() {
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.bottom.equalToSuperview().offset(-10)
            maker.top.equalToSuperview().offset(10)
        }
    }
}

final class HomeView: UIView {

    private var cardView = CardHighlight(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        createConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }


    func bindTo(viewModel: HomeCardViewModel) {
        cardView.bindTo(viewModel: viewModel)
    }
}

extension HomeView {
    func createConstraints() {
        addSubview(cardView)
        cardView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.bottom.equalToSuperview().offset(-10)
            maker.top.equalToSuperview().offset(10)
        }
    }
}
