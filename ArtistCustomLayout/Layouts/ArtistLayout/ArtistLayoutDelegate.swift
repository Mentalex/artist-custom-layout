//
//  ArtistLayoutDelegate.swift
//  ArtistCustomLayout
//
//  Created by Alex Tapia on 15/06/20.
//  Copyright © 2020 AlexTapia. All rights reserved.
//

import UIKit

protocol ArtistLayoutDelegate: class {
  func layoutType(for section: Int) -> ArtistLayoutType
}

// MARK: - Defaul Implementation
extension ArtistLayoutDelegate {
  func layoutType(for section: Int) -> ArtistLayoutType {
    return .list
  }
}
