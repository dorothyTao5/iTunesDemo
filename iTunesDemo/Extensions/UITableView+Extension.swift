//
//  SearchingTBVCell.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/4.
//

import Foundation
import UIKit

extension UITableView {
    /// - Parameter name: UITableViewCell type
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - indexPath: location of cell in tableView.
    /// - Returns: UITableViewCell object with associated class name.
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }
    
    func updateTableViewHeaderHeight() {
            if let headerView = tableHeaderView {
                let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
                
                if height != headerView.frame.height {
                    var newFrame = headerView.frame
                    newFrame.size.height = height
                    headerView.frame = newFrame
                    tableHeaderView = headerView
                }
            }
        }
}
