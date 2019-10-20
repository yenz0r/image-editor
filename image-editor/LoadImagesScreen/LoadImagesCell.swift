//
//  LoadImagesCell.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

final class LoadImagesCell: UICollectionViewCell {
    private var imageView: UIImageView!

    var image: UIImage? {
        didSet {
            self.imageView.image = self.image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView = self.setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        self.imageView.image = nil
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5.0)
        }
        imageView.layer.cornerRadius = 5.0
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }
}
