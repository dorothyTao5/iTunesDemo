//
//  SearchingViewModel.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/11.
//

import Foundation
import RxSwift

class SearchingViewModel {
    
    public let searchOutput : PublishSubject<SearchOutput> = PublishSubject()
    public let error : PublishSubject<Error> = PublishSubject()

    func fetchSongs(searchedStr str:String) {
        SearchAPIServices.sharedInstance.getSearch(input: SearchInput(term: str)).done { [weak self] data in
            guard let self = self else { return }
            self.searchOutput.onNext(data)
        }.catch { error in
            self.error.onNext(error)
        }
    }
}
