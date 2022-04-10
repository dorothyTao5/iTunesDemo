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
    
    weak var delegate: SearchingVCDelegate?
    
    init(withDelegate delegate: SearchingVCDelegate) {
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCell(indexPath: indexPath)
//        let cell = tableView.cellForRow(at: indexPath) as? SearchingTBVCell
//        let vc = CurrentSongViewController()
//        vc.modalPresentationStyle = .fullScreen
//        vc.heroid = "\(indexPath.row)"
//        vc.setupView(heroID: "\(indexPath.row)", data: searchOutput.results[indexPath.row], photo: cell!.ivPhoto.image!)
//        //        player.pause()
//        present(vc, animated: true, completion: nil)
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
