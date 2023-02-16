//
//  Diffable+Extension.swift
//  SwiftyMDLib
//
//  Created by Sargis Gevorgyan on 2/16/23.
//

import UIKit

public extension UICollectionViewDiffableDataSource {

    func applySnapshotWithReloadData(snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animatingDifferences: Bool, completion: (() -> Void)? = nil) {
        if #available(iOS 15.0, *) {
            applySnapshotUsingReloadData(snapshot, completion: completion)
        } else {
            apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        }
    }
}

public extension UITableViewDiffableDataSource {

    func applySnapshotWithReloadData(snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animatingDifferences: Bool, completion: (() -> Void)? = nil) {
        if #available(iOS 15.0, *) {
            if animatingDifferences {
                self.apply(snapshot, animatingDifferences: true, completion: completion)
            } else {
                applySnapshotUsingReloadData(snapshot, completion: completion)
            }
        } else {
            apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        }
    }
}
