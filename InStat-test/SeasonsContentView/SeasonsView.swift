//
//  SeasonsView.swift
//  InStat-test
//
//  Created by Денис Рубцов on 23.05.2022.
//

import UIKit

protocol SeasonsViewControllerDelegate {
    func routeToStandingsModule(seasons: [Season], leagueId: String, seasonYear: String)
}

class SeasonsView: UITableView {

    var presenter: SeasonsPresenterProtocol?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SeasonsTableViewCell.self, forCellReuseIdentifier: SeasonsTableViewCell.cellId)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        return tableView
    }()

    var seasons: [Season] = []

    init() {
        super.init(frame: .zero, style: .plain)
        dataSource = self
        delegate = self
        register(SeasonsTableViewCell.self, forCellReuseIdentifier: SeasonsTableViewCell.cellId)
        showsVerticalScrollIndicator = false
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SeasonsView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SeasonsTableViewCell.cellId, for: indexPath) as? SeasonsTableViewCell else {
            return SeasonsTableViewCell()
        }
        let season = seasons[indexPath.row]
        cell.setup(season: season)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let season = seasons[indexPath.row]
        presenter?.showStandingsScreen(seasonYear: season.year.description)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


