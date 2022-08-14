//
//  LeaguesPresenter.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import Foundation

protocol LeaguesPresenterProtocol: AnyObject {
    func showSeasonScreen(leagueId: String)
}

class LeaguesPresenter: LeaguesPresenterProtocol {
    
    unowned let viewController: MainViewController
    unowned let contentView: LeaguesView
    let router: Router?
    
    required init(viewController: MainViewController, contentView: LeaguesView, router: Router) {
        self.viewController = viewController
        self.contentView = contentView
        self.router = router
        viewController.setNavigationBarTitle(to: "Leagues")
        loadData()
    }
    
    func loadData() {
        NetworkService.shared.dataRequest(with: "\(Constant.mainUrl)/leagues", objectType: Leagues.self) { [self] result in
            switch result {
            case .success(let object):
                contentView.leagues = object.data
                DispatchQueue.main.async {
                    self.contentView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func showSeasonScreen(leagueId: String) {
        router?.showSeasonsScreen(leagueId: leagueId, from: viewController.navigationController)
    }
    
}

