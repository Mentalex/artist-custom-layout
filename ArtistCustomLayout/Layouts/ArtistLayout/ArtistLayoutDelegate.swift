//
//  ArtistLayoutDelegate.swift
//  ArtistCustomLayout
//
//  Created by Alex Tapia on 15/06/20.
//  Copyright © 2020 AlexTapia. All rights reserved.
//

import UIKit

protocol ArtistLayoutDelegate: class {
  func layout(typeFor section: Int) -> ArtistLayoutType
  func layout(headerHeightAt section: Int) -> CGFloat
  func layout(cellHeightAt indexPath: IndexPath) -> CGFloat
}

// MARK: - Defaul Implementation
extension ArtistLayoutDelegate {
  func layout(typeFor section: Int) -> ArtistLayoutType {
    return .list
  }
  
  func layout(headerHeightAt section: Int) -> CGFloat {
    return 60
  }
  
  func layout(cellHeightAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}
