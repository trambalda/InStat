//
//  StandingsPresenter.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import Foundation

protocol StandingsPresenterProtocol: AnyObject {
    init(view: StandingsViewProtocol)
    func loadData(id: String, year: String)
}

class StandingsPresenter: StandingsPresenterProtocol {
    unowned let view: StandingsViewProtocol
    
    required init(view: StandingsViewProtocol) {
        self.view = view
    }
    
    func loadData(id: String, year: String) {
        NetworkService.shared.dataRequest(with: "\(Constant.mainUrl)/leagues/\(id)/standings?season=\(year)&sort=asc", objectType: LeagueStandings.self) { [self] result in
            switch result {
            case .success(let object):
                view.setStandings(object.data.standings)
            case .failure(let error):
                print(error)
            }
        }
    }
}
