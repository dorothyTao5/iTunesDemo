//
//  SearchingViewController.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/2/17.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift
import AVFoundation

class SearchingViewController: BaseViewController {

    private lazy var searchView = CustomTextFieldView()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(cellWithClass: SearchingTBVCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.backgroundView = EmptyView(withType: .noResult, onPosition: .upper)
        tableView.delegate = self
        return tableView
    }()
    
    private let dataSource = SearchingDataSource()
    private var player = AVPlayer()
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        setupUI()
        searchViewEventHandler()
        dataSourceEventHandler()
    }
}
//MARK: - Private Extension
private extension SearchingViewController {
    func setupUI() {
        view.backgroundColor = R.color.white_black()
        
        view.addSubview(searchView)
        view.addSubview(tableView)

        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.right.bottom.left.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func searchViewEventHandler() {
        searchView.endEditingCallback = { [weak self] searchedStr in
            self?.dataSource.fetchSongs(searchedStr: searchedStr)
        }
    }
    
    func dataSourceEventHandler() {
        dataSource.playPauseCallback = { [weak self] indexPath in
            guard let self = self else { return }
            if let isPlayingIndex = self.dataSource.resultsData.firstIndex(where: { $0.isPlaying }), isPlayingIndex != indexPath.row {
                self.dataSource.resultsData[isPlayingIndex].isPlaying = false
                self.tableView.reloadRows(at: [IndexPath(row: isPlayingIndex, section: 0)], with: .automatic)
            }
            self.dataSource.resultsData[indexPath.row].isPlaying.toggle()
            if self.dataSource.resultsData[indexPath.row].isPlaying {
                guard let previewUrl = self.dataSource.resultsData[indexPath.row].previewUrl else { return }
                let url = URL(string: previewUrl)!
                let playerItem = AVPlayerItem(url: url)
                self.player.replaceCurrentItem(with: playerItem)
                self.player.play()
            } else {
                self.player.pause()
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        dataSource.didUpdateDataCallback = { [weak self] in
            guard let self = self else { return }
            self.tableView.backgroundView = self.dataSource.resultsData.isEmpty ? EmptyView(withType: .noResult, onPosition: .upper) : nil
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate
extension SearchingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? SearchingTBVCell
        let vc = CurrentSongViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.heroid = "\(indexPath.row)"
        vc.setupView(heroID: "\(indexPath.row)", data: dataSource.resultsData[indexPath.row], photo: cell!.ivPhoto.image!)
//        player.pause()
        present(vc, animated: true, completion: nil)
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
