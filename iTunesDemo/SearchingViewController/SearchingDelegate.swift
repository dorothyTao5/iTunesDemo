//
//  SearchingDelegate.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/10.
//

import UIKit

protocol SearchingVCDelegate: AnyObject {
    func selectedCell(indexPath: IndexPath)
}

class SearchingDelegate: NSObject, UITableViewDelegate {
    
    private var viewModel = SearchingViewModel()
    
    weak var delegate: SearchingVCDelegate?
    
    init(withDelegate delegate: SearchingVCDelegate, viewModel: SearchingViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
