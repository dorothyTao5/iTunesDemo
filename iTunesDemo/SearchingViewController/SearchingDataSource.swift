//
//  SearchingDataSource.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/9.
//

import UIKit
import RxSwift

class SearchingDataSource: NSObject, UITableViewDataSource {
    
    var searchOutput = SearchOutput()
    var focusedSongIndex = MusicIndexes()
    var playPauseCallback: ((MusicIndexes) -> Void)?
    var presentVCCallback: ((UIViewController) -> Void)?
    var updateTbvCallback: (() -> Void)?
    var didScrollCallback: ((Int) -> Void)?
//MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchOutput.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SearchingTBVCell.self, for: indexPath)
        let colorIndex = indexPath.row.truncatingRemainder(dividingBy: 6)
        cell.setupCell(data: searchOutput.results[indexPath.row], colorIndex: colorIndex)
        cell.setHeroID(id: "\(indexPath.row)")
        cell.playPauseCallBack = { [weak self] in
            guard let self = self else { return }
            self.focusedSongIndex = self.searchOutput.updateSelectedData(at: indexPath)
            self.playPauseCallback?(self.focusedSongIndex)
        }
        return cell
    }
}
//MARK: - UITableViewDelegate
extension SearchingDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let cell = tableView.cellForRow(at: indexPath) as? SearchingTBVCell
        focusedSongIndex.current = indexPath
        let vc = CurrentSongViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.heroid = "\(indexPath.row)"
        vc.setupView(heroID: "\(indexPath.row)", data: searchOutput.results, indexPath: indexPath, photo: cell!.ivPhoto.image!)
        vc.delegate = self
        presentVCCallback?(vc)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        if yPosition >= 48 {
            didScrollCallback?(0)
        } else if yPosition < 48 {
           didScrollCallback?(1)
        }
    }
}
//MARK: - CurrentSongVCDelegate
extension SearchingDataSource: CurrentSongVCDelegate {
    func updatePlayingData() {
        self.focusedSongIndex = self.searchOutput.updateSelectedData(at: focusedSongIndex.current)
    }
    
    func updateSearchingVCTBV(currentIndex: Int) {
        for i in 0..<searchOutput.results.count {
            searchOutput.results[i].isPlaying = false
        }
        searchOutput.results[currentIndex].isPlaying = true
        self.updateTbvCallback?()
    }
}
