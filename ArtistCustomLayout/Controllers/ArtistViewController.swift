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
  
  // MARK: - Computed Properties
  private var layout: ArtistLayout? {
    return collectionView.collectionViewLayout as? ArtistLayout
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
  
  // MARK: - Private Methods
  private func setupCollectionView() {
    layout?.delegate = self
    collectionView.register(ItemViewCell.self, forCellWithReuseIdentifier: Element.cell.id)
    collectionView.register(
      UINib(nibName: "HeaderReusableView", bundle: nil),
      forSupplementaryViewOfKind: Element.header.kind,
      withReuseIdentifier: Element.header.id
    )
    collectionView.register(
      UINib(nibName: "FooterReusableView", bundle: nil),
      forSupplementaryViewOfKind: Element.footer.kind,
      withReuseIdentifier: Element.footer.id
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
    let identifier = (kind == Element.header.kind) ? Element.header.id : Element.footer.id
    let view = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind, withReuseIdentifier: identifier, for: indexPath
    )
    view.backgroundColor = (kind == Element.header.kind) ? .black : .red
    return view
  }
}

// MARK: - ArtistLayout Delegate
extension ArtistViewController: ArtistLayoutDelegate {
  
  func layout(typeFor section: Int) -> ArtistLayoutType {
    return DataManager.sections[section].type
  }
  
  func layout(headerHeightAt section: Int) -> CGFloat {
   return 60
  }
  
  func layout(footerHeigtAt section: Int) -> CGFloat {
    return 40
  }
  
  func layout(cellHeightAt indexPath: IndexPath) -> CGFloat {
    return indexPath.section == 0 ? 45 : 60
  }
}
