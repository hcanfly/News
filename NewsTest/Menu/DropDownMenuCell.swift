//
//  DropDownMenuCell.swift
//  NewsTest
//
//  Created by Gary on 3/5/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//


import UIKit


final class DropdownMenuCell: UITableViewCell {
    static let reuseIdentifier = "dropdownmenucellid"
    
    var iconView: UIImageView!
    var nameLabel: UILabel!
    var separatorView: UIView!
    let iconSize: CGFloat = 15.0
    var indentation: CGFloat = 0
    var customColor: UIColor?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.iconView = UIImageView(frame: frame)
        self.iconView.contentMode = UIView.ContentMode.scaleAspectFit
        self.iconView.clipsToBounds = true
        self.addSubview(self.iconView)

        self.backgroundColor = .black
        self.nameLabel = UILabel(frame: frame)
        self.nameLabel.font = UIFont(name: "HelveticaNeue", size: 17)!
        self.nameLabel.textAlignment = .left
        self.addSubview(self.nameLabel)

        self.separatorView = UIView(frame: frame)
        self.separatorView.backgroundColor = UIColor(red: 200.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        self.addSubview(self.separatorView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var iconFrame = CGRect(x: self.indentation, y: 0, width: iconSize, height: iconSize)
        iconFrame = iconFrame.offsetBy(dx: 15 + 10, dy: (self.bounds.height - iconFrame.height) / 2)
        self.iconView.frame = iconFrame

        var textFrame: CGRect
        textFrame = CGRect(x: self.indentation + 65, y: 0, width: self.bounds.width - 65 - 15 - self.indentation, height: self.bounds.height)
        self.nameLabel.frame = textFrame

        let sepFrame = CGRect(x: 10, y: self.bounds.height - 1, width: self.bounds.width - 20, height: 0.5)
        self.separatorView.frame = sepFrame

        self.iconView.tintColor = self.customColor != nil ? self.customColor : UIColor(hex: 0x263238)
        self.nameLabel.textColor = self.customColor != nil ? self.customColor : .white // UIColor(hex: 0x263238)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func enable(_ enabled: Bool) {
        self.iconView.alpha = enabled ? 1 : 0.25
        self.nameLabel.alpha = enabled ? 1 : 0.25
        self.isUserInteractionEnabled = enabled

    }
}


extension UIColor {
    convenience init(hex: Int) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0) )
    }
}

