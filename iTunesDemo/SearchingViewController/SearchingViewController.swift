//
//  SearchingViewController.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/2/17.
//

import UIKit

class SearchingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink.withAlphaComponent(0.3)
    }
}
//MARK: - API
extension SearchingViewController {
    func fetchSongs(searchedStr str:String) {
        SearchAPIServices.sharedInstance.getSearch(input: SearchInput(term: str)).done { data in
            print("data",data)
        }.catch { error in
            log.error(error)
        }
    }
}
