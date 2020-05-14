//
//  AlignmentFlowLayout.swift
//  Vain_ios
//
//  Created by Sargis Gevorgyan on 5/14/20.
//  Copyright © 2020 MagicDevs. All rights reserved.
//

import UIKit

public enum FlowAlignment : Int {
    case justyfied
    case left
    case center
    case right
}

public class AlignmentFlowLayout: UICollectionViewFlowLayout {
    
    private var cache: [IndexPath : UICollectionViewLayoutAttributes]?
    
    public var alignment: FlowAlignment? {
        didSet {
            invalidateLayout()
        }
    }
    
    public override func prepare() {
        super.prepare()
        
        cache = [:]
    }
    
    public override func invalidateLayout() {
        super.invalidateLayout()
        
        cache = [:]
    }
    
    public override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        if #available(iOS 13.0, *) {
            return false
        }
        return true
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if #available(iOS 13.0, *) {
            return false
        }
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        if alignment == .justyfied {
            return attributes
        }
        
        return layoutAttributesForElements(in: attributes)
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if alignment == .justyfied {
            return super.layoutAttributesForItem(at: indexPath)
        }
        
        return attributes(at: indexPath)
    }
    
    //MARK - Private
    private func layoutAttributesForElements(in attributes: [UICollectionViewLayoutAttributes]?) -> [UICollectionViewLayoutAttributes]? {
        
        var alignedAttributes = [UICollectionViewLayoutAttributes]()
        
        for item in attributes ?? [UICollectionViewLayoutAttributes]() {
            if item.representedElementKind != nil {
                alignedAttributes.append(item)
            } else {
                if let attr = layoutAttributesForItem(attributes: item, indexPath: item.indexPath) {
                    alignedAttributes.append(attr)
                }
            }
        }
        
        return alignedAttributes
    }
    
    private func layoutAttributesForItem(attributes: UICollectionViewLayoutAttributes, indexPath: IndexPath) ->UICollectionViewLayoutAttributes? {
        return attributesFor(at: attributes, indexPath: indexPath)
    }
    
    private func attributes(at indexPath: IndexPath) ->UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as! UICollectionViewLayoutAttributes
        
        return attributesFor(at: attributes, indexPath: indexPath)
    }
    
    
    private func attributesFor(at attributes: UICollectionViewLayoutAttributes?, indexPath:IndexPath) ->UICollectionViewLayoutAttributes? {
        if let attributes = cache?[indexPath] {
            return attributes
        }
        
        var itemsInRow = [UICollectionViewLayoutAttributes]()
        
        let totalInSection:Int = self.collectionView?.numberOfItems(inSection: indexPath.section) ?? 0
        let width = self.collectionView?.bounds.width ?? 0
        let rowFrame = CGRect(x: 0, y: attributes?.frame.minY ?? 0, width: width, height: attributes?.frame.height ?? 0)
        
        // Go forward to the end or the row or section items
        var index = indexPath.row

        while index < totalInSection - 1 {
            index += 1
            
            let next = super.layoutAttributesForItem(at: IndexPath(row: index, section: indexPath.section))?.copy() as! UICollectionViewLayoutAttributes
            
            if !next.frame.intersects(rowFrame) {
                break
            }
            itemsInRow.append(next)
        }
        
        // Current item
        if let attributes = attributes {
            itemsInRow.append(attributes)
        }
        
        // Go backward to the start of the row or first item
        index = indexPath.row

        while index > 0 {
            
            index -= 1
            let prev = super.layoutAttributesForItem(at: IndexPath(row: index, section: indexPath.section))?.copy() as! UICollectionViewLayoutAttributes
            
            if !prev.frame.intersects(rowFrame) {
                break
            }
            itemsInRow.append(prev)
        }
        
        // Total items width include spacings
        var totalWidth = minimumInteritemSpacing * CGFloat((itemsInRow.count - 1))
        
        for item in itemsInRow {
            totalWidth += item.frame.width
        }
        
        // Correct sorting in row
        
        itemsInRow.sort { (obj1, obj2) -> Bool in
            return obj1.indexPath < obj2.indexPath
        }
        
        var rect = CGRect.zero
        
        for item in itemsInRow {
            var frame = item.frame
            
            var x = frame.origin.x
            
            if rect.isEmpty {
                switch alignment {
                case .left:
                    x = sectionInset.left
                case .center:
                    x = (width - totalWidth) / 2.0
                case .right:
                    x = width - totalWidth - self.sectionInset.right
                default: break
                }
            } else {
                x = rect.maxX + minimumInteritemSpacing
            }
            
            frame.origin.x = x
            item.frame = frame;
            rect = frame;
            
            self.cache?[item.indexPath] = item
        }
        
        cache?[indexPath] = attributes
        
        return attributes
    }
}
