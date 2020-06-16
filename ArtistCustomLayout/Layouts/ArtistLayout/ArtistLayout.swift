//
//  ArtistLayout.swift
//  ArtistCustomLayout
//
//  Created by Alex Tapia on 14/06/20.
//  Copyright © 2020 AlexTapia. All rights reserved.
//

import UIKit

// Internal Typealias for `ArtistLayoutElement`
typealias Element = ArtistLayoutElement

// Internal Typealias for `ArtistLayoutElement`
typealias LayoutAttributes = UICollectionViewLayoutAttributes

/// Custom Artist View Layout.
/// It is responsable to adapt all CollectionView components for specific Device and Orientation.
class ArtistLayout: UICollectionViewLayout {
  
  // MARK: - Public Properties
  weak var delegate: ArtistLayoutDelegate?
  var numberOfColumns: Int = 4
  var padding: CGFloat = 8
  var headerHeight: CGFloat = 60
  
  // MARK: - Private Properties
  /// Cache of calculated Attributes
  private var cache: [Element: [IndexPath: LayoutAttributes]] = [:]
  
  /// The CollectionView's variable content height
  private var contentHeight: CGFloat = .zero
  
  // MARK: - Computed Properties
  /// The CollectionView's variable content width
  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else { return .zero }
    let contentInset = collectionView.contentInset
    return collectionView.bounds.width - (contentInset.left + contentInset.right)
  }
  
  // MARK: - Overrides
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    guard let collectionView = collectionView, cache.isEmpty else { return }
    prepareCache()
    
    for section in 0..<collectionView.numberOfSections {
      // Setup Header Attributes
      prepareHeader(forSection: section)
      
      // Get Layout Type for Section
      // NOTE: If delegate or method is not implemented use list type by default
      let layoutType: ArtistLayoutType = delegate?.layoutType(for: section) ?? .list
      switch layoutType {
      case .list:
        listLayout(collectionView: collectionView, in: section)
      case .grid:
        gridLayout(collectionView: collectionView, in: section)
      default:
        break
      }
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let cells = cache[.cell]?.filter { $0.value.frame.intersects(rect) }.map { $0.value } ?? []
    let headers = cache[.header]?.filter { $0.value.frame.intersects(rect) }.map { $0.value } ?? []
    return cells + headers
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[.cell]?[indexPath]
  }
  
  override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard elementKind == Element.header.kind else { return nil }
    return cache[.header]?[indexPath]
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return (self.collectionView?.bounds ?? newBounds) == newBounds
  }
  
  override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
    super.invalidateLayout(with: context)
    contentHeight = .zero
    cache = [:]
  }
}

// MARK: - ArtistLayout Core
extension ArtistLayout {
  
  private func prepareCache() {
    cache[.cell] = [IndexPath: LayoutAttributes]()
    cache[.header] = [IndexPath: LayoutAttributes]()
  }
  
  private func prepareHeader(forSection section: Int) {
    let attributes = UICollectionViewLayoutAttributes(
      forSupplementaryViewOfKind: Element.header.kind,
      with: IndexPath(item: 0, section: section)
    )
    attributes.frame = CGRect(x: 0, y: contentHeight, width: contentWidth, height: headerHeight)
    contentHeight = attributes.frame.maxY
    cache[.header]?[attributes.indexPath] = attributes
  }
  
  private func listLayout(collectionView: UICollectionView, in section: Int) {
    for item in 0..<collectionView.numberOfItems(inSection: section) {
      let indexPath = IndexPath(item: item, section: section)
      
      // Initialize and set Frame
      var frame = CGRect(x: 0, y: contentHeight, width: contentWidth, height: headerHeight)
      frame = frame.insetBy(dx: padding, dy: padding)
      
      // Initialize, set and save Attributes
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = frame
      cache[.cell]?[indexPath] = attributes
      
      // Update Content Height
      contentHeight = attributes.frame.maxY
    }
  }
  
  private func gridLayout(collectionView: UICollectionView, in section: Int) {
    // Values used to set Item Asset Frame
    let itemWidth = contentWidth / CGFloat(numberOfColumns)
    let xOffsets = Array(0..<numberOfColumns).map { CGFloat($0) * itemWidth }
    var column = 0
    
    // Setup Y Offsets
    var yOffsets: [CGFloat] = .init(repeating: contentHeight, count: numberOfColumns)
    
    let numberOfItems = collectionView.numberOfItems(inSection: section)
    for item in 0..<numberOfItems {
      let indexPath = IndexPath(item: item, section: section)
      
      // Initialize and set Frame
      var frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: itemWidth, height: itemWidth)
      frame = frame.insetBy(dx: padding, dy: padding)
      
      // Initialize, set and save Attributes
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = frame
      cache[.cell]?[indexPath] = attributes
      
      // Update Content Height
      contentHeight = attributes.frame.maxY
      
      // Update Offsets and column for next item
      yOffsets[column] = yOffsets[column] + itemWidth
      column = column < numberOfColumns - 1 ? column + 1 : 0
    }
  }
}
