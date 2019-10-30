//
//  FiltersView.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol FiltersView {
    func reloadData()
}

class FiltersViewImpl: UIViewController {
    private var imageView: UIView!
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView = self.setupImageView()
        self.collectionView = self.setupCollectionView()
        self.configureNavBar()
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10.0)
            make.height.equalTo(imageView.snp.width)
        }
        return imageView
    }

    private func configureNavBar() {
        let barItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNextButtonTap))
        self.navigationItem.rightBarButtonItem = barItem
    }

    @objc private func handleNextButtonTap() {

    }

    private func setupCollectionView() -> UICollectionView {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(FiltersCell.self, forCellWithReuseIdentifier: "filtersCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }
}

extension FiltersViewImpl: FiltersView {
    func reloadData() {
        self.collectionView.reloadData()
    }
}

extension FiltersViewImpl: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.presenter.filters.count
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filtersCell", for: indexPath) as! FiltersCell
        //cell.image = self.presenter.filteredImages[indexPath.row]
        return cell
    }
}

extension FiltersViewImpl: UICollectionViewDelegate {

}

extension FiltersViewImpl: UICollectionViewDelegateFlowLayout {

}
