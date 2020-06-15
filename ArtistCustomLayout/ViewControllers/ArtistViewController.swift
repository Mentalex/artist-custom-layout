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
    collectionView.register(GridItemViewCell.self, forCellWithReuseIdentifier: "Cell")
  }
}

// MARK: - CollectionView DataSource
extension ArtistViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return DataManager.items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "Cell", for: indexPath
      ) as? GridItemViewCell
    cell?.backgroundColor = .darkGray
    return cell ?? UICollectionViewCell()
  }
}
