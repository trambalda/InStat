//
//  Router.swift
//  InStat-test
//
//  Created by Денис Рубцов on 23.05.2022.
//

import UIKit

protocol RouterMain {
    var assembler: AssemblerProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func showSeasonsScreen(leagueId: String, from: UINavigationController?)
    func showStandingsScreen(leagueId: String, seasonYear: String, seasons: [Season], from: UINavigationController?)
}

class Router: RouterProtocol {
    var assembler: AssemblerProtocol?
    
    init(assembler: AssemblerProtocol) {
        self.assembler = assembler
    }
    
    func showSeasonsScreen(leagueId: String, from: UINavigationController?) {
        guard let vc = assembler?.createSeasonsScreen(leagueId: leagueId, router: self) else { return }
        from?.pushViewController(vc, animated: true)
    }
    
    func showStandingsScreen(leagueId: String, seasonYear: String, seasons: [Season], from: UINavigationController?) {
        guard let vc = assembler?.createStandingsScreen(leagueId: leagueId, seasonYear: seasonYear, seasons: seasons, router: self) else { return }
        from?.pushViewController(vc, animated: true)
    }

}

