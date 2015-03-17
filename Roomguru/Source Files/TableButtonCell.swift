//
//  TableButtonCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class TableButtonCell: UITableViewCell {
    
    private struct aStruct { static var staticVar: String = "TableButtonCellReuseIdentifier"}
    
    class var reuseIdentifier: String {
        get { return aStruct.staticVar }
        set { aStruct.staticVar = newValue }
    }
    
    let button = UIButton.buttonWithType(.System) as UIButton
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addSubview(button)
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(button) { (button) in
            
            let margin: CGFloat = 10
            
            button.top == button.superview!.top + margin
            button.bottom == button.superview!.bottom - margin
            button.centerX == button.superview!.centerX
            button.width == 300
        }
    }
}
