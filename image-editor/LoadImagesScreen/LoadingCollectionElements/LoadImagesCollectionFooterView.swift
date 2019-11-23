//
//  LoadImagesCollectionFooterView.swift
//  image-editor
//
//  Created by yenz0redd on 24.11.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

final class LoadImagesCollectionFooterView: UICollectionReusableView {
    private var loader: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.loader = UIActivityIndicatorView(style: .large)
        self.loader.color = .lightGray
        self.addSubview(self.loader)
        self.loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.loader.stopAnimating()
    }
}

// MARK: - LoadImagesAnimationDelegate implementation
extension LoadImagesCollectionFooterView: LoadImagesAnimationDelegate {
    func startLoading() {
        self.loader.startAnimating()
    }

    func stopLoading() {
        self.loader.stopAnimating()
    }
}
