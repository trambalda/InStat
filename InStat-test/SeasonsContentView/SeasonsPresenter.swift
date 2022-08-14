//
//  SeasonsPresenter.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import Foundation

protocol SeasonsPresenterProtocol: AnyObject {
    func showStandingsScreen(seasonYear: String)
}

class SeasonsPresenter: SeasonsPresenterProtocol {
    unowned let viewController: MainViewController
    unowned let contentView: SeasonsView
    let router: Router?

    let leagueId: String!

    required init(leagueId: String, viewController: MainViewController, contentView: SeasonsView, router: Router) {
        self.viewController = viewController
        self.contentView = contentView
        self.router = router
        self.leagueId = leagueId
        viewController.setNavigationBarTitle(to: "Seasons")
        loadData(leagueId: leagueId)
    }
    
    func loadData(leagueId: String) {
        NetworkService.shared.dataRequest(with: "\(Constant.mainUrl)/leagues/\(leagueId)/seasons", objectType: LeagueSeasons.self) { [self] result in
            switch result {
            case .success(let object):
                contentView.seasons = object.data.seasons
                DispatchQueue.main.async {
                    self.contentView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func showStandingsScreen(seasonYear: String) {
        router?.showStandingsScreen(leagueId: leagueId, seasonYear: seasonYear, seasons: contentView.seasons, from: viewController.navigationController)
    }

}
