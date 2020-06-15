//
//  ArtistViewController.swift
//  ArtistCustomLayout
//
//  Created by Alex Tapia on 14/06/20.
//  Copyright © 2020 AlexTapia. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
  
  // MARK: - Private Methods
  private func setupCollectionView() {
    collectionView.register(ItemViewCell.self, forCellWithReuseIdentifier: Element.cell.id)
    collectionView.register(
      UINib(nibName: "HeaderReusableView", bundle: nil),
      forSupplementaryViewOfKind: Element.header.kind,
      withReuseIdentifier: Element.header.id
    )
  }
}

// MARK: - CollectionView DataSource
extension ArtistViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return DataManager.sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return DataManager.sections[section].items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Element.cell.id, for: indexPath)
    cell.backgroundColor = .darkGray
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind, withReuseIdentifier: Element.header.id, for: indexPath
    )
    header.backgroundColor = .black
    return header
  }
}

// MARK: - ArtistLayout Delegate
extension ArtistViewController: ArtistLayoutDelegate {
  func collection(_ collectionView: UICollectionView, layoutType type: ArtistLayoutType, for section: Int) -> ArtistLayoutType {
    return DataManager.sections[section].type
  }
}
