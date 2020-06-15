//
//  ArtistLayout.swift
//  ArtistCustomLayout
//
//  Created by Alex Tapia on 14/06/20.
//  Copyright © 2020 AlexTapia. All rights reserved.
//

import UIKit

class ArtistLayout: UICollectionViewLayout {
  
  // MARK: - Public Properties
  var numberOfColumns: Int = 4
  var padding: CGFloat = 8
  
  // MARK: - Private Properties
  /// Cache of calculated Attributes
  private var cache: [UICollectionViewLayoutAttributes] = []
  
  /// The CollectionView's variable content width
  private var contentWidth: CGFloat = .zero
  
  /// The CollectionView's variable content height
  private var contentHeight: CGFloat = .zero
  
  // MARK: - Overrides
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    guard let collectionView = collectionView, cache.isEmpty else { return }
    
    // Calculate Content Width
    let insetWidth = collectionView.contentInset.left + collectionView.contentInset.right
    contentWidth = collectionView.bounds.width - insetWidth
    
    // Values used to set Item Asset Frame
    let itemWidth = contentWidth / CGFloat(numberOfColumns)
    let xOffsets = Array(0..<numberOfColumns).map { CGFloat($0) * itemWidth }
    var yOffsets: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
    var column = 0
    
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)
      
      // Initialize and set Frame
      var frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: itemWidth, height: itemWidth)
      frame = frame.insetBy(dx: padding, dy: padding)
      
      // Initialize, set and save Attributes
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = frame
      cache.append(attributes)
      
      // Update Content Height
      contentHeight = max(contentHeight, frame.maxY)
      
      // Update Offsets and column for next item
      yOffsets[column] = yOffsets[column] + itemWidth
      column = column < numberOfColumns - 1 ? column + 1 : 0
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return cache.filter { $0.frame.intersects(rect) }
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return (self.collectionView?.bounds ?? newBounds) == newBounds
  }
  
  override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
    super.invalidateLayout(with: context)
    contentWidth = .zero
    contentHeight = .zero
    cache = []
  }
}
