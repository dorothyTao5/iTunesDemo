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
import RxSwift

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
        tableView.tableHeaderView = searchView
        return tableView
    }()
    
    private let dataSource = SearchingDataSource()
    
    private var viewModel = SearchingViewModel()
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        setupUI()
        searchViewEventHandler()
        dataSourceEventHandler()
        setupBindings()
    }
}
//MARK: - Private Extension
private extension SearchingViewController {
    func setupUI() {
        configureNavigationAppearance(color: .clear, foregroundColor: R.color.black_white()!.withAlphaComponent(0.4))
        view.backgroundColor = R.color.white_black()
        
        view.addSubview(tableView)

        searchView.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupBindings() {
        viewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (error) in
                log.error(error)
            }).disposed(by: disposeBag)
        
        viewModel
            .searchOutput
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.tableView.backgroundView = data.results.isEmpty ? EmptyView(withType: .noResult, onPosition: .center) : nil
                self.dataSource.searchOutput = data
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    func searchViewEventHandler() {
        searchView.endEditingCallback = { [weak self] searchedStr in
            guard let self = self else { return }
            self.viewModel.fetchSongs(searchedStr: searchedStr)
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
            if currentSong.isPlaying {
                PlayerManager.shared.playMusic(currentSong: currentSong)
            } else {
                PlayerManager.shared.stopPlayer()
            }
        }
        
        dataSource.updateTbvCallback = { [weak self] in
            self?.tableView.reloadData()
        }
        
        dataSource.presentVCCallback = { vc in
            self.present(vc, animated: true, completion: nil)
        }
        
        dataSource.didScrollCallback = { [weak self] int in
            guard let self = self else { return }
            if int == 0 {
                self.setUpAttribute(title: self.searchView.textFeild.text ?? "", in: R.color.black_white()!)
            } else {
                self.setUpAttribute(title: "", in: R.color.white_black()!)
            }
            
        }
    }
}
