//
//  SeasonsPresenter.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import Foundation

protocol SeasonsPresenterProtocol: AnyObject {
    init(view: SeasonsViewProtocol)
    func loadData(id: String)
}

class SeasonsPresenter: SeasonsPresenterProtocol {
    unowned let view: SeasonsViewProtocol
    
    required init(view: SeasonsViewProtocol) {
        self.view = view
    }
    
    func loadData(id: String) {
        NetworkService.shared.dataRequest(with: "\(Constant.mainUrl)/leagues/\(id)/seasons", objectType: LeagueSeasons.self) { [self] result in
            switch result {
            case .success(let object):
                view.setSeasons(object.data.seasons)
            case .failure(let error):
                print(error)
            }
        }
    }
}
