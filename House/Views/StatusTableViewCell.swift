//
//  StatusTableViewCell.swift
//  House
//
//  Created by andrew on 8/9/2018.
//  Copyright © 2018年 andrew. All rights reserved.
//

import UIKit
import RxSwift

class StatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var switchButton:UISwitch!
    @IBOutlet weak var statusLabel:UILabel!

    @IBInspectable var cornerRadius: CGFloat = 2    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5

    var isLightOn:Bool = false {
        didSet {
            self.switchButton.setOn(isLightOn, animated: true)
            var status = "off"
            if isLightOn {
                status = "on"
            }
            self.statusLabel.text = "Status: \(status)"            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
        
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }

}

