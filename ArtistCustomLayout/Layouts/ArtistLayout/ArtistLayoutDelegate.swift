//
//  ArtistLayoutDelegate.swift
//  ArtistCustomLayout
//
//  Created by Alex Tapia on 15/06/20.
//  Copyright © 2020 AlexTapia. All rights reserved.
//

import UIKit

protocol ArtistLayoutDelegate {
  func collection(_ collectionView: UICollectionView, layoutType type: ArtistLayoutType, for section: Int) -> ArtistLayoutType
}

// MARK: - Defaul Implementation
extension ArtistLayoutDelegate {
  func collection(_ collectionView: UICollectionView, layoutType type: ArtistLayoutType, for section: Int) -> ArtistLayoutType {
    return .list
  }
}
