//
//  FiltersCell.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

class FiltersCell: UICollectionViewCell {
    private var imageView: UIImageView!

    var image: UIImage? = nil {
        didSet {
            self.imageView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.imageView = self.setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        self.imageView.layer.cornerRadius = self.bounds.height / 2
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
