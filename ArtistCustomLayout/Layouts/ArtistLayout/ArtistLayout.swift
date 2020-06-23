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
  
  // MARK: - Private Properties
  /// Cache of calculated Attributes
  private var cache: [Element: [IndexPath: LayoutAttributes]] = [:]
  
  /// The CollectionView's variable content height
  private var contentHeight: CGFloat = .zero
  
  /// Default Height when height for cell or header its not defined.
  private var defaultHeight: CGFloat = 60
  
  private var listOffsetY: CGFloat = .zero
  private var currentColumnList: Int = 0
  
  // MARK: - Computed Properties
  /// The CollectionView's variable content width
  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else { return .zero }
    let contentInset = collectionView.contentInset
    return collectionView.bounds.width - (contentInset.left + contentInset.right)
  }
  
  /// The Width of List section type. It's diffrent when is iPhone or iPad.
  private var listWidth: CGFloat {
    let device: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    return device == .phone ? contentWidth : contentWidth / 2
  }
  
  /// Numbers of List Columns,  if is iPhone show just one column of lisy
  private var numbersOfListColumns: Int {
    let device: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    return device == .phone ? 1 : 2
  }
  
  // MARK: - Overrides
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    guard let collectionView = collectionView, cache.isEmpty else { return }
    prepareCache()
    
    for section in 0..<collectionView.numberOfSections {
      // Get Layout Type for Section
      // NOTE: If delegate or method is not implemented use list type by default
      let layoutType: ArtistLayoutType = delegate?.layout(typeFor: section) ?? .list
      switch layoutType {
      case .list:
        listLayout(collectionView: collectionView, in: section)
      case .grid:
        gridLayout(collectionView: collectionView, in: section)
      }
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let cells = cache[.cell]?.filter { $0.value.frame.intersects(rect) }.map { $0.value } ?? []
    let headers = cache[.header]?.filter { $0.value.frame.intersects(rect) }.map { $0.value } ?? []
    let footers = cache[.footer]?.filter { $0.value.frame.intersects(rect) }.map{ $0.value } ?? []
    return cells + headers + footers
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[.cell]?[indexPath]
  }
  
  override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    switch elementKind {
    case Element.header.kind:
      return cache[.header]?[indexPath]
    case Element.footer.kind:
      return cache[.footer]?[indexPath]
    default:
      return nil
    }
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    guard let oldWidth = collectionView?.bounds.width else { return false }
    return oldWidth != newBounds.width
  }
  
  override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
    super.invalidateLayout(with: context)
    contentHeight = .zero
    currentColumnList = 0
    listOffsetY = .zero
    cache = [:]
  }
}

// MARK: - ArtistLayout Core
extension ArtistLayout {
  
  private func prepareCache() {
    cache[.cell] = [IndexPath: LayoutAttributes]()
    cache[.header] = [IndexPath: LayoutAttributes]()
    cache[.footer] = [IndexPath: LayoutAttributes]()
  }
  
  private func prepareSupplementary(element: Element, section: Int, origin: CGPoint, width: CGFloat) -> CGFloat {
    guard let height = heightOfSupplementary(element, at: section), height > 0 else { return .zero }
    let attributes = UICollectionViewLayoutAttributes(
      forSupplementaryViewOfKind: element.kind,
      with: IndexPath(item: 0, section: section)
    )
    attributes.frame = CGRect(x: origin.x, y: origin.y, width: width, height: height)
    contentHeight = max(contentHeight, attributes.frame.maxY)
    cache[element]?[attributes.indexPath] = attributes
    return height
  }
  
  private func listLayout(collectionView: UICollectionView, in section: Int) {
    // Setup initial values
    let width = listWidth
    let originX = CGFloat(currentColumnList) * width
    let originY = currentColumnList == 0 ? contentHeight : listOffsetY
    var origin = CGPoint(x: originX, y: originY)
    
    // Setup Header Attributes
    let headerHeight = prepareSupplementary(element: .header, section: section, origin: origin, width: width)
    
    // Update Y position
    origin.y = currentColumnList == 0 ? contentHeight : origin.y + headerHeight
    
    // Setup Items Attributes
    for item in 0..<collectionView.numberOfItems(inSection: section) {
      let indexPath = IndexPath(item: item, section: section)
      
      // Initialize and set Frame
      let height = delegate?.layout(cellHeightAt: indexPath) ?? defaultHeight
      var frame = CGRect(x: origin.x, y: origin.y, width: width, height: height)
      frame = frame.insetBy(dx: padding, dy: padding)
      
      // Initialize, set and save Attributes
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = frame
      cache[.cell]?[indexPath] = attributes
      
      // Update Content Height
      contentHeight = max(contentHeight, attributes.frame.maxY)
      origin.y += height
    }
    
    // Setup Footer Attributes
    _ = prepareSupplementary(element: .footer, section: section, origin:  origin, width: width)
    
    // Update Values
    listOffsetY = currentColumnList == 0 ? listOffsetY : contentHeight
    currentColumnList = currentColumnList == 0 ? 1 : 0
    if UIDevice.current.userInterfaceIdiom == .phone {
      listOffsetY = contentHeight
      currentColumnList = 0
    }
  }
  
  private func gridLayout(collectionView: UICollectionView, in section: Int) {
    // Setup Header Attributes
    var origin = CGPoint(x: 0, y: contentHeight)
    _ = prepareSupplementary(element: .header, section: section, origin: origin, width: contentWidth)
    
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
      contentHeight = max(contentHeight, attributes.frame.maxY)
      
      // Update Offsets and column for next item
      yOffsets[column] = yOffsets[column] + itemWidth
      column = column < numberOfColumns - 1 ? column + 1 : 0
    }
    
    // Setup Footer Attributes
    origin.y = contentHeight
    _ = prepareSupplementary(element: .footer, section: section, origin:  origin, width: contentWidth)
  }
}

extension ArtistLayout {
  
  private func heightOfSupplementary(_ element: Element, at section: Int) -> CGFloat? {
    switch element {
    case .header:
      return delegate?.layout(headerHeightAt: section)
    case .footer:
      return delegate?.layout(footerHeigtAt: section)
    default:
      return nil
    }
  }
}
