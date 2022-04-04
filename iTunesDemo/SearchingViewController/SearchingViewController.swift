//
//  SearchingViewController.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/2/17.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

class SearchingViewController: BaseViewController {

    private lazy var searchView = CustomTextFieldView()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(cellWithClass: SearchingTBVCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var resultsData = [Results]()
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        searchViewEventHandler()
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
            self?.fetchSongs(searchedStr: searchedStr)
        }
    }
}
//MARK: - UITableViewDataSource
extension SearchingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SearchingTBVCell.self, for: indexPath)
        let colorIndex = indexPath.row.truncatingRemainder(dividingBy: 6)
        cell.setupCell(data: resultsData[indexPath.row], colorIndex: colorIndex)
        return cell
    }
}
//MARK: - UITableViewDelegate
extension SearchingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
//MARK: - API
extension SearchingViewController {
    func fetchSongs(searchedStr str:String) {
        SearchAPIServices.sharedInstance.getSearch(input: SearchInput(term: str)).done { [weak self] data in
            guard let self = self else { return }
            self.resultsData = data.results
            self.tableView.reloadData()
        }.catch { error in
            log.error(error)
        }
    }
}
