//
//  DropDownMenuController.swift
//  NewsTest
//
//  Created by Gary on 3/5/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit


public struct DropdownMenuItem {
    public let name: String
    public let icon: UIImage?
    public var indentation: CGFloat = 0
    public var customColor: UIColor?
    public var disabled: Bool = false

    public init(name: String, icon: UIImage?) {
        self.name = name
        self.icon = icon
    }
}

final class DropdownMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var buttonFrame: CGRect?

    fileprivate var anchor: CGPoint = CGPoint(x: 0, y: 0)
    fileprivate var items: [DropdownMenuItem]? = nil
    fileprivate var barTintColor: UIColor?
    fileprivate var count: Int = 0
    fileprivate var tableView: UITableView?
    fileprivate var menuView: UIView?
    fileprivate var clipView: UIView?
    fileprivate var bgView: UIView!
    fileprivate let kCellHeight: CGFloat = 44.0
    fileprivate var titleButton: UIButton?
    fileprivate let caretSize: CGFloat = 14.0
    fileprivate let clipSize: CGFloat = 14.0 * 1.5
    fileprivate var completion: ((IndexPath) -> Void)?

    func initWithItems(_ items: [DropdownMenuItem], anchor: CGPoint, barTintColor: UIColor, completion: @escaping (IndexPath) -> Void) {
        self.items = items
        self.count = self.items!.count
        self.anchor = anchor
        self.barTintColor = barTintColor
        self.completion = completion
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // Get the height the the navbar so we can position the table view beneath it.
        let titleBarHeight = self.navigationController!.navigationBar.frame.size.height
        // In iOS 13 getting status bar height from UIApplication is supposedly deprecated
        // need this: let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let yoffset = titleBarHeight + statusBarHeight

        // Create a view to hold the menu.
        let width: CGFloat = self.buttonFrame!.width
        let height: CGFloat = CGFloat(self.count) * kCellHeight
        let menuFrame = CGRect(x: self.buttonFrame!.minX, y: self.buttonFrame!.origin.y, width:width, height: height)

        let bgFrame = CGRect(x: 0, y: yoffset, width: self.view.frame.width, height: self.view.frame.height)
        self.bgView = UIView(frame: bgFrame)
        self.bgView.clipsToBounds = true
        self.view.addSubview(self.bgView)

        // Build the menu starting with the background.
        self.menuView = UIView(frame: menuFrame)
        if let menuView = self.menuView {
            menuView.backgroundColor = UIColor.black
            menuView.layer.shadowColor = UIColor.black.cgColor
            menuView.layer.shadowOpacity = 0.2
            menuView.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.bgView.addSubview(menuView)

            menuView.frame = menuView.frame.offsetBy(dx: 0, dy: -menuView.frame.height)

            self.tableView = UITableView(frame: menuView.bounds, style: UITableView.Style.plain)
            if let tableView = self.tableView {
                tableView.delegate = self
                tableView.dataSource = self
                tableView.isUserInteractionEnabled = true
                tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
                self.tableView?.backgroundColor = .black
                menuView.addSubview(tableView)

                tableView.register(DropdownMenuCell.self, forCellReuseIdentifier: DropdownMenuCell.reuseIdentifier)

                // Start at the bottom of the table view.
                let numberOfRows = tableView.numberOfRows(inSection: 0)
                let indexPath = IndexPath(row: numberOfRows-1, section: 0)
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: false)
            }

            let stubView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
            menuView.addSubview(stubView)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showMenu {}
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            self.updateLayouts()
            }) { (UIViewControllerTransitionCoordinatorContext) -> Void in
        }
    }

    func updateLayouts() {
        if let bgView = self.bgView {
            let titleBarHeight = self.navigationController!.navigationBar.frame.size.height
            let statusBarHeight: CGFloat = 20.0
            let yoffset = titleBarHeight+statusBarHeight

            let bgFrame = CGRect(x: 0, y: yoffset, width: self.view.frame.width, height: self.view.frame.height)
            bgView.frame = bgFrame
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: UITouch in touches {
            let pos = touch.location(in: self.menuView)
            if !self.menuView!.bounds.contains(pos) {
                hideMenu {
                }
                break
            }
        }
    }

    fileprivate func showMenu(_ completion: @escaping () -> Void) {
        self.tableView?.contentOffset = CGPoint.zero
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.bgView.backgroundColor = UIColor(red: 38.0/255.0, green: 50.0/255.0, blue: 56.0/255.0, alpha: 0.25)
            self.menuView!.frame = CGRect(x: 0, y: 0, width: self.menuView!.frame.width, height: self.menuView!.frame.height)
            }, completion: { _ in
                completion()
        })
    }

    fileprivate func hideMenu(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear, .allowUserInteraction], animations: {
            self.bgView.backgroundColor = nil
            self.menuView!.frame = CGRect(x: 0, y: -self.menuView!.frame.height, width: self.menuView!.frame.width, height: self.menuView!.frame.height)
            }, completion: { _ in
                self.dismiss(animated: false, completion: {
                    completion()
                })
        })
    }

    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropdownMenuCell.reuseIdentifier) as! DropdownMenuCell
        cell.textLabel!.frame = cell.bounds
        cell.separatorView.isHidden = indexPath.row == self.count - 1

        if let item = self.items?[indexPath.row] {
            cell.nameLabel!.text = item.name
            cell.iconView.image = item.icon?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.indentation = item.indentation
            cell.customColor = item.customColor

            cell.enable(!item.disabled)
        }

        return cell
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideMenu {
            self.completion!(indexPath)
        }
    }
}


