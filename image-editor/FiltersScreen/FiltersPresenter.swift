//
//  FiltersPresenter.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol FiltersPresenter: AnyObject {
    func viewDidAppear()
    func handleFilterChoose(at indexPath: IndexPath)
    func imageAtIndex(_ index: Int) -> UIImage?
    var processedImages: [String: UIImage?] { get }
    func handleNextButtonTap()
    func handleShowFilterSettings(at index: Int)
    func hideSettingsFilterView()
    func handleUpdateKeyValue(tag: Int, value: Float)
    func isPro(at index: Int) -> Bool
}

final class FiltersPresenterImpl {
    private let model: FiltersModel
    private weak var view: FiltersView?
    private let router: FiltersRouter
    private var image: UIImage?
    private var resultImage: UIImage?

    private var filteredImages = [String: UIImage?]()

    var processedImages: [String: UIImage?] {
        return self.filteredImages
    }

    private var keysToUpdate = [String]()
    private var filterToUpdate = ""

    private let filtersNames: [String]
    private var selectedIndexPath: IndexPath? = IndexPath(row: 0, section: 0)

    init(model: FiltersModel,
         view: FiltersView,
         coordinator: FiltersRouter,
         image: UIImage?) {
        self.model = model
        self.view = view
        self.router = coordinator
        self.image = image

        var result = [String]()
        for key in self.model.filters.keys {
            result.append(key)
        }
        self.filtersNames = result
    }
}

// MARK: - FiltersPresenter implementation
extension FiltersPresenterImpl: FiltersPresenter {
    func isPro(at index: Int) -> Bool {
        let filter = self.filtersNames[index]
        guard let keys = self.model.filters[filter], let rightKeys = keys else { return false }
        return !rightKeys.isEmpty
    }

    func handleShowFilterSettings(at index: Int) {
        self.view?.clearSettingsView()
        self.filterToUpdate = self.filtersNames[index]
        self.view?.setupTitleFilterText(self.filterToUpdate)
        guard let keys = self.model.filters[self.filterToUpdate], let rightKeys = keys else {
            self.router.showErrorAlert()
            return
        }
        for (index, key) in rightKeys.enumerated() {
            self.view?.addSettingsSlider(
                name: key.name,
                min: key.minimumValue,
                max: key.maximumValue,
                initial: key.currentValue,
                tag: index
            )
            self.keysToUpdate.append(key.name)
        }
        self.view?.showSettingsView()
    }

    func hideSettingsFilterView() {
        self.keysToUpdate = []
        self.view?.hideSettingsView()
    }

    func handleUpdateKeyValue(tag: Int, value: Float) {
        self.model.updateValue(for: self.filterToUpdate, by: self.keysToUpdate[tag], on: value)
        self.router.showLoadingAlert()
        self.model.applyFilter(for: self.filterToUpdate, image: self.image) { [weak self] image in
            DispatchQueue.main.async {
                self?.view?.setupImage(image)
                self?.resultImage = image
                self?.router.hideLoadingAlert()
            }
        }
    }

    func viewDidAppear() {
        self.view?.setupImage(self.image)
        self.router.showLoadingAlert()
        self.model.applyAllFilters(for: self.image) { [weak self] dict in
            guard let self = self else { return }
            for filter in self.filtersNames {
                self.filteredImages[filter, default: nil] = dict[filter] ?? nil
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.view?.reloadData()
                self.router.hideLoadingAlert()
            }
        }
    }

    func imageAtIndex(_ index: Int) -> UIImage? {
        guard let image = self.filteredImages[self.filtersNames[index]] else {
            return nil
        }
        return image
    }

    func handleFilterChoose(at indexPath: IndexPath) {
        if let selectedIndexPath = self.selectedIndexPath {
            guard selectedIndexPath != indexPath else { return }
            self.view?.deselectCell(at: selectedIndexPath)
        }
        self.selectedIndexPath = indexPath
        self.view?.selectCell(at: indexPath)
        self.router.showLoadingAlert()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 2) {
            self.model.applyFilter(for: self.filtersNames[indexPath.row], image: self.image) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.view?.setupImage(image)
                    self.resultImage = image
                    self.router.hideLoadingAlert()
                }
            }
        }
    }

    func handleNextButtonTap() {
        if self.resultImage == nil {
            self.router.showColorsScreen(with: self.image)
        } else {
            self.router.showColorsScreen(with: self.resultImage)
        }
    }
}
