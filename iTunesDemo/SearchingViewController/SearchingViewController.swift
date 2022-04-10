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
        tableView.backgroundView = EmptyView(withType: .noResult, onPosition: .upper)
        
        return tableView
    }()
    
    private let dataSource = SearchingDataSource()
    private var delegate: SearchingDelegate?
    private var player = AVPlayer()
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        delegate = SearchingDelegate(withDelegate: self)
        tableView.delegate = delegate
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
        dataSource.playPauseCallback = { [weak self] indexes in
            guard let self = self else { return }
            if let previousIndex = indexes.previous {
                self.tableView.reloadRows(at: [previousIndex], with: .automatic)
            }
            self.tableView.reloadRows(at: [indexes.current], with: .automatic)

            let currentSong = self.dataSource.searchOutput.results[indexes.current.row]
            guard let previewUrl = currentSong.previewUrl,
                      currentSong.isPlaying else {
                          self.player.pause()
                          return
                      }
            let url = URL(string: previewUrl)!
            let playerItem = AVPlayerItem(url: url)
            self.player.replaceCurrentItem(with: playerItem)
            self.player.play()
        }
        
        dataSource.didUpdateDataCallback = { [weak self] in
            guard let self = self else { return }
            self.tableView.backgroundView = self.dataSource.searchOutput.results.isEmpty ? EmptyView(withType: .noResult, onPosition: .upper) : nil
            self.tableView.reloadData()
        }
    }
}
extension SearchingViewController: SearchingVCDelegate {
    func selectedCell(indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? SearchingTBVCell
        let vc = CurrentSongViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.heroid = "\(indexPath.row)"
        vc.setupView(heroID: "\(indexPath.row)", data: dataSource.searchOutput.results[indexPath.row], photo: cell!.ivPhoto.image!)
        //        player.pause()
        present(vc, animated: true, completion: nil)
    }
}
