//
//  UITableView+Tools.swift
//  Alamofire
//
//  Created by Sargis Gevorgyan on 3/30/20.
//

import UIKit
import Foundation

public protocol TableViewDelegation: UITableViewDelegate, UITableViewDataSource {
}

public extension Date {
    var hourWithDatTimeIndicator: String {
        let formater = DateFormatter()
        formater.dateFormat = "h a"
        let hour = formater.string(from: self)
        return hour
    }
}

public extension UITableView {
    func setActualHeight() {
        reloadData()
        layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.mdLayout.setHeight(type: .equal(constant: self.contentSize.height))
        }
    }
}

public extension UITableView {
    public func removeHeaderFooter() {
        // Remove space between sections.
        sectionHeaderHeight = 0
        sectionFooterHeight = 0

        // Remove space at top and bottom of tableView.
        tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: CGFloat.leastNormalMagnitude)))
        tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: CGFloat.leastNormalMagnitude)))
    }
}
