//
//  DropdownMenu.swift
//  NewsTest
//
//  Created by Gary on 3/5/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit



extension ViewController {

    fileprivate struct Action {
        static let tappedTitle = #selector(handleTitleTapped)
    }


    func buildTitle(_ title: String, enabled: Bool) {
        self.navigationItem.title = ""

        var newTitle: String?
        if (title.isEmpty) {
            newTitle = self.newsCategories[0]
        } else {
            newTitle = title
        }

        if self.titleButton != nil {
            self.titleLabel?.removeFromSuperview()
            self.titleLabel = nil

            self.titleButton?.removeFromSuperview()
            self.titleButton = nil
            self.navigationItem.titleView = nil
        }

        if self.navigationController != nil {
            self.titleButton = UIButton(type: UIButton.ButtonType.custom)

            if let button = self.titleButton {
                self.titleButton?.isEnabled = enabled
                self.navigationItem.titleView = self.titleButton

                let frame = CGRect(x: 0, y: 0,
                                   width: self.navigationController!.navigationBar.frame.width - (2 * 65.0),
                    height: self.navigationController!.navigationBar.frame.height)

                button.frame = frame

                button.addTarget(self, action: Action.tappedTitle, for: UIControl.Event.touchUpInside)
                let center = CGPoint(x: self.navigationController!.navigationBar.center.x, y: self.navigationController!.navigationBar.frame.height / 2)
                button.center = center

                self.titleLabel = UILabel(frame: button.bounds)
                if let label = self.titleLabel {
                    label.frame = button.bounds//CGRectOffset(label.frame, 0, 0)
                    button.addSubview(label)

                    let font: UIFont = UIFont(name: "HelveticaNeue", size: 17)!
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = NSTextAlignment.left
                    paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingMiddle

                    let attrs = [
                        NSAttributedString.Key.font : font,
                        NSAttributedString.Key.paragraphStyle : paragraphStyle,
                        NSAttributedString.Key.baselineOffset : NSNumber(value: 0 as Float)]
                    let attrStr = NSAttributedString(string: newTitle!, attributes: attrs)
                    label.attributedText = attrStr
                }
            }
        }
    }

    @objc func handleTitleTapped() {
        didTapTitle()
    }

func didTapTitle() {
    var array = [DropdownMenuItem]()
    var dropdownMenuItem: DropdownMenuItem!

    //var indentation: CGFloat = 0
    for item in self.newsCategories {
        //indentation += 15.0

        let displayName = item

        dropdownMenuItem = DropdownMenuItem(name: displayName, icon: nil)
        dropdownMenuItem.indentation = 0    //indentation

        if item == self.titleLabel?.text! {
            dropdownMenuItem.customColor = UIColor(hex: 0x3489e3)
        }

        array.append(dropdownMenuItem)
    }

    let dropdownMenuController = DropdownMenuController()
    dropdownMenuController.buttonFrame = self.navigationController?.navigationBar.bounds
    dropdownMenuController.initWithItems(array, anchor: CGPoint(x: 65.0 + 10.0, y: self.navigationController!.navigationBar.frame.height), barTintColor: UIColor(white: 0.96, alpha: 1.0)) {
        indexPath -> Void in

            if indexPath.row < self.newsCategories.count {
                let item = self.newsCategories[indexPath.row]
                DispatchQueue.main.async {
                    self.setCategory(to: item)
                }
            }

    }

    let navigationController = UINavigationController(rootViewController: dropdownMenuController)
    navigationController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    self.present(navigationController, animated: false, completion: nil)
}

}
