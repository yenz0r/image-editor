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

    init() {
        super.init(frame: .zero)

        self.imageView = self.setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = self.bounds.height / 2
        return imageView
    }
}
