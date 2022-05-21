//
//  LeaguesPresenter.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import Foundation

protocol LeaguesPresenterProtocol: AnyObject {
    init(view: LeaguesViewProtocol)
    func loadData()
}

class LeaguesPresenter: LeaguesPresenterProtocol {
    unowned let view: LeaguesViewProtocol
    
    required init(view: LeaguesViewProtocol) {
        self.view = view
    }
    
    func loadData() {
        NetworkService.shared.dataRequest(with: "https://api-football-standings.azharimm.site/leagues", objectType: Leagues.self) { [self] result in
            switch result {
            case .success(let object):
                view.setLeagues(object.data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
