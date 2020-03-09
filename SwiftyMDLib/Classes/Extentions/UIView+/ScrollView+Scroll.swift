
//
//  ScrollView+.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit

public extension UITableView {
    
    func scrollToBottom() {

        DispatchQueue.main.async {

            guard self.numberOfSections > 0 else { return }

            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)

            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)

                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }
            
            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }
            
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            if self.contentOffset.y > self.contentSize.height {
                UIView.animate(withDuration: 0.1) {
                    self.contentOffset.y += self.contentSize.height - self.contentOffset.y
                }
            }
        }
    }
    
    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < numberOfSections && row < numberOfRows(inSection: section)
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
        
            if self.numberOfSections > 0 {
                if self.numberOfRows(inSection: 0) > 0 {
                    var indexPath = IndexPath(row: 0, section: 0)
                    
                    while !self.indexPathIsValid(indexPath) {
                        let section = indexPath.section + 1
                        indexPath = IndexPath(row: 0, section: section)
                        // If we're down to the last section, attempt to use the first row
                        if indexPath.section > 10 {
                            return
                        }
                    }
                    self.scrollToRow(at: indexPath, at: .top, animated: false)
                }
            }
        }
    }
    
    
}
