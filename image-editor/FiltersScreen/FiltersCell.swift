//
//  FiltersCell.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

final class FiltersCell: UICollectionViewCell {
    private var imageView: UIImageView!
    private var selectedView: UIView!
    private var proStatus: UILabel!

    var image: UIImage? = nil {
        didSet {
            self.imageView.image = image
        }
    }

    var isPro: Bool = false {
        didSet {
            self.proStatus.isHidden = !self.isPro
        }
    }

    var onLongTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.imageView = self.setupImageView()
        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        self.imageView.addGestureRecognizer(longGestureRecognizer)
        self.selectedView = self.setupSelectedView()

        self.proStatus = self.setupProStatusLabel()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = image
        self.image = nil
        self.onLongTap = nil
    }

    override func layoutSubviews() {
        self.imageView.layer.cornerRadius = self.bounds.height / 2
        self.imageView.clipsToBounds = true
    }

    private func setupProStatusLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Black", size: 12.0)!
        label.layer.backgroundColor = UIColor.orange.cgColor
        label.layer.masksToBounds = true

        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
        }
        label.text = "pro"
        label.isHidden = true
        return label
    }

    func selectCell() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.selectedView.transform = .identity
            }
        )
    }

    func deselectCell() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.selectedView.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
        )
    }

    private func setupSelectedView() -> UIView {
        let containerView = UIView()
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)

        let imageView = UIImageView()
        imageView.image = UIImage(named: "select-mark")
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.6)
        }
        imageView.layer.cornerRadius = self.bounds.width * 0.6 / 2
        imageView.clipsToBounds = true

        containerView.transform = CGAffineTransform(scaleX: 0, y: 0)

        return containerView
    }

    @objc private func handleLongTap() {
        self.onLongTap?()
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        return imageView
    }
}
