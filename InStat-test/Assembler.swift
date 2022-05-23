//
//  Assembler.swift
//  InStat-test
//
//  Created by Денис Рубцов on 24.05.2022.
//

import UIKit

protocol AssemblerProtocol {
    func createLeaguesScreen(router: Router) -> UIViewController
    func createSeasonsScreen(leagueId: String, router: Router) -> UIViewController
    func createStandingsScreen(leagueId: String, seasonYear: String, seasons: [Season], router: Router) -> UIViewController
}

class Assembler: AssemblerProtocol {
    
    func createLeaguesScreen(router: Router) -> UIViewController {
        let contentView = LeaguesView()
        let viewController = MainViewController(contentView: contentView)
        let presenter = LeaguesPresenter(
            viewController: viewController, contentView: contentView, router: router)
        contentView.presenter = presenter
        return viewController
    }

    func createSeasonsScreen(leagueId: String, router: Router) -> UIViewController {
        let contentView = SeasonsView()
        let viewController = MainViewController(contentView: contentView)
        let presenter = SeasonsPresenter(
            leagueId: leagueId,
            viewController: viewController, contentView: contentView, router: router)
        contentView.presenter = presenter
        return viewController
    }

    func createStandingsScreen(leagueId: String, seasonYear: String, seasons: [Season], router: Router) -> UIViewController {
        let contentView = StandingsView()
        let viewController = MainViewController(contentView: contentView)
        let presenter = StandingsPresenter(
            leagueId: leagueId, seasonYear: seasonYear, seasons: seasons,
            viewController: viewController, contentView: contentView, router: router)
        contentView.presenter = presenter
        return viewController
    }

}
