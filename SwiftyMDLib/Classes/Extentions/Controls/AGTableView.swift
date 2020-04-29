//
//  AGTableView.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import AVFoundation
import UIKit

open class AGTableView: UITableView {
    
    public var heightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.associateConstraints()
        defaultInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.associateConstraints()
        defaultInit()
    }
    
    func defaultInit(){
        self.keyboardDismissMode = .onDrag
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.tableFooterView = UIView(frame: .zero)
        self.tableHeaderView = UIView(frame: .zero)
        self.sectionFooterHeight = 0
        self.sectionHeaderHeight = 0
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.heightConstraint != nil {
            self.heightConstraint.constant = self.contentSize.height
        }
        else{
            print("Set a heightConstraint to set cocontentSize with same")
        }
    }
    
    func associateConstraints() {
        // iterate through all text view's constraints and identify
        // height
        
        for constraint: NSLayoutConstraint in constraints {
            if constraint.firstAttribute == .height {
                if constraint.relation == .equal {
                    heightConstraint = constraint
                }
            }
        }
    }
}
