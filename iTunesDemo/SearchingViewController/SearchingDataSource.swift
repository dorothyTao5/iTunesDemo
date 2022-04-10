//
//  SearchingDataSource.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/9.
//

import UIKit

class SearchingDataSource: NSObject, UITableViewDataSource {
    var searchOutput = SearchOutput()
    
    var playPauseCallback: ((MusicIndexes) -> Void)?
    var didUpdateDataCallback: (() -> Void)?
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
            let indexes = self.searchOutput.updateSelectedData(at: indexPath)
            self.playPauseCallback?(indexes)
        }
        return cell
    }
}
//MARK: - API
extension SearchingDataSource {
    func fetchSongs(searchedStr str:String) {
        SearchAPIServices.sharedInstance.getSearch(input: SearchInput(term: str)).done { [weak self] data in
            guard let self = self else { return }
            self.searchOutput = data
            self.didUpdateDataCallback?()
        }.catch { error in
            log.error(error)
        }
    }
}
