//
//  FiltersView.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol FiltersView: AnyObject {
    func reloadData()
    func setupImage(_ image: UIImage?)
    func setupTitleFilterText(_ text: String)
    func addSettingsSlider(name: String,
                           min: Float,
                           max: Float,
                           initial: Float,
                           tag: Int)
    func showSettingsView()
    func hideSettingsView()
    func clearSettingsView()
}

final class FiltersViewImpl: UIViewController {
    private var imageView: UIImageView!
    private var collectionView: UICollectionView!
    private var settingsView: UIView!
    private var filterTitleLabel: UILabel!
    private var settingsStackView: UIStackView!

    private let settingsViewHeight = 200.0
    private let collectionViewHeight = 70.0

    private var isSettingShown = false

    var presenter: FiltersPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.configureMainView()

        self.imageView = self.setupImageView()
        self.collectionView = self.setupCollectionView()
        self.settingsView = self.setupSettingsView()
        self.filterTitleLabel = self.setupFilterTitleLabel()
        self.settingsStackView = self.setupSettingsStackView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter.viewDidAppear()
    }

    private func configureMainView() {
        self.view.backgroundColor = .black
    }

    @objc private func handleCloseSettingsButtonTap() {
        self.presenter.hideSettingsFilterView()
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10.0)
            make.height.equalTo(imageView.snp.width)
        }
        return imageView
    }

    private func setupSettingsView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30.0
        view.clipsToBounds = true

        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(13.0)
            make.top.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.settingsViewHeight)
        }

        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .red
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.size.equalTo(40.0)
        }
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(handleCloseSettingsButtonTap), for: .touchUpInside)

        return view
    }

    private func setupSettingsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill

        self.settingsView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(self.filterTitleLabel.snp.bottom)
        }

        return stackView
    }

    private func setupFilterTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 20.0)!
        label.textAlignment = .center
        label.backgroundColor = .clear

        self.settingsView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(15.0)
            make.height.equalTo(20.0)
        }

        return label
    }

    private func configureNavBar() {
        let barItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped))
        self.navigationItem.rightBarButtonItem = barItem
        self.navigationItem.title = "Filters Screen"
    }

    @objc private func nextButtonTapped() {
        self.presenter.handleNextButtonTap()
    }

    private func setupCollectionView() -> UICollectionView {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(FiltersCell.self, forCellWithReuseIdentifier: "filtersCell")
        collectionView.delegate = self
        collectionView.dataSource = self

        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.collectionViewHeight)
        }

        return collectionView
    }
}

extension FiltersViewImpl: FiltersView {
    func setupTitleFilterText(_ text: String) {
        self.filterTitleLabel.text = text
    }

    func clearSettingsView() {
        self.settingsStackView.subviews.forEach { $0.removeFromSuperview() }
    }

    func addSettingsSlider(name: String, min: Float, max: Float, initial: Float, tag: Int) {
        let containerView = UIView()
        containerView.backgroundColor = .white

        let slider = UISlider()
        slider.minimumValue = max
        slider.maximumValue = min
        slider.value = initial
        slider.tag = tag
        slider.addTarget(self, action: #selector(handleUpdateSettingsValue(slider:)), for: .touchUpInside)

        containerView.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(2 * self.settingsView.bounds.width / 3 - 30.0)
        }

        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.width.equalTo(self.settingsView.bounds.width / 3)
        }
        label.text = name

        self.settingsStackView.addArrangedSubview(containerView)
    }

    @objc private func handleUpdateSettingsValue(slider: UISlider) {
        let tag = slider.tag
        self.presenter.handleUpdateKeyValue(tag: tag, value: slider.value)
    }

    func showSettingsView() {
        guard !self.isSettingShown else { return }
        self.isSettingShown = true
        UIView.animate(
            withDuration: 1.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.8,
            options: [.curveEaseIn],
            animations: {
                self.settingsView.transform = self.settingsView.transform.translatedBy(x: 0, y: CGFloat(-self.settingsViewHeight - 10.0))
            },
            completion: { _ in
                print("") // TODO +animation
            }
        )
    }

    func hideSettingsView() {
        self.isSettingShown = false
        UIView.animate(
            withDuration: 1,
            animations: {
                self.settingsView.transform = .identity
            }
        )
    }

    func reloadData() {
        self.collectionView.reloadData()
    }

    func setupImage(_ image: UIImage?) {
        self.imageView.image = image
    }
}

extension FiltersViewImpl: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.processedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filtersCell", for: indexPath) as! FiltersCell
        cell.image = self.presenter.imageAtIndex(indexPath.row)
        cell.onLongTap = {
            self.presenter.handleShowFilterSettings(at: indexPath.row)
        }
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        cell.addGestureRecognizer(longGesture)
        return cell
    }

    @objc private func handleLongTap(recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: self.collectionView)
        guard let indexPath = self.collectionView.indexPathForItem(at: point) else {
            return
        }
        self.presenter.handleShowFilterSettings(at: indexPath.row)
    }
}

extension FiltersViewImpl: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.handleFilterChoose(at: indexPath)
    }
}

extension FiltersViewImpl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewHeight, height: self.collectionViewHeight)
    }
}
