//
//  StandingsPresenter.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import UIKit

protocol StandingsPresenterProtocol: AnyObject {
    func loadData(leagueId: String, seasonYear: String)
    func setNavigationBarTitle(seasonYear: String)
}

protocol SelectViewDelegateProtocol {
    func changeSeason(to newYear: String)
}

class StandingsPresenter: StandingsPresenterProtocol {
    
    unowned let viewController: MainViewController
    unowned let contentView: StandingsView
    let router: Router?
    
    let leagueId: String!
    var seasonYear: String!
    let seasons: [Season]!

    required init(leagueId: String, seasonYear: String, seasons: [Season], viewController: MainViewController, contentView: StandingsView, router: Router) {
        self.viewController = viewController
        self.contentView = contentView
        self.router = router
        self.leagueId = leagueId
        self.seasonYear = seasonYear
        self.seasons = seasons
        setNavigationBarTitle(seasonYear: seasonYear)
        loadData(leagueId: leagueId, seasonYear: seasonYear)
        
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Change", style: .plain, target: self, action: #selector(changeSeasonButtonTapped))
        viewController.navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func changeSeasonButtonTapped() {
        let vc = SelectViewController(seasons: seasons, delegate: self)
        viewController.present(vc, animated: true)
    }
    
    func loadData(leagueId: String, seasonYear: String) {
        NetworkService.shared.dataRequest(with: "\(Constant.mainUrl)/leagues/\(leagueId)/standings?season=\(seasonYear)&sort=asc", objectType: LeagueStandings.self) { [self] result in
            switch result {
            case .success(let object):
                contentView.standings = object.data.standings
                DispatchQueue.main.async {
                    self.contentView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setNavigationBarTitle(seasonYear: String) {
        viewController.setNavigationBarTitle(to: "Standings \(seasonYear)")
    }

}

extension StandingsPresenter: SelectViewDelegateProtocol {
    public func changeSeason(to newYear: String) {
        loadData(leagueId: leagueId, seasonYear: newYear)
        setNavigationBarTitle(seasonYear: newYear)
    }
}
