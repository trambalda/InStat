//
//  StandingsView.swift
//  InStat-test
//
//  Created by Денис Рубцов on 23.05.2022.
//

import UIKit

class StandingsView: UITableView {

    var presenter: StandingsPresenterProtocol?
    var standings: [Standing] = []

    init() {
        super.init(frame: .zero, style: .plain)
        dataSource = self
        delegate = self
        register(StandingsTableViewCell.self, forCellReuseIdentifier: StandingsTableViewCell.cellId)
        showsVerticalScrollIndicator = false
        backgroundColor = .white
        if #available(iOS 15, *) {
            sectionHeaderTopPadding = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension StandingsView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return standings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StandingsTableViewCell.cellId, for: indexPath) as? StandingsTableViewCell else {
            return SeasonsTableViewCell()
        }
        let standing = standings[indexPath.row]
        cell.setup(standing: standing)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = Constant.backgroundColor
        
        let nameLabel = UILabel()
        nameLabel.text = "Team name"
        nameLabel.font = Constant.getBoldFont(size: 14)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        
        var teamFieldWidth = Constant.Standings.teamFieldWidth
        if Constant.isPortraitOrientation() == false {
            teamFieldWidth += Constant.Standings.nameWidth
        }
        header.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: header.leadingAnchor, constant: teamFieldWidth),
        ])
        
        var leading = Constant.Standings.inset
        for i in 0..<Constant.Standings.totalStats {
            let label = UILabel()
            label.font = Constant.getBoldFont(size: 14)
            label.textColor = .white
            label.textAlignment = .center

            var itemWidth = Constant.Standings.itemWidth
            if i >= Constant.Standings.totalStats - 4 { itemWidth *= 1.5 }
            if i >= Constant.Standings.totalStats - 1 { itemWidth += itemWidth }
            if standings.count > 0 {
                let abbr = standings[0].stats[i].abbreviation
                label.text = abbr
            }
            
            header.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: header.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: leading),
                label.widthAnchor.constraint(equalToConstant: itemWidth),
            ])
            if i >= Constant.Standings.itemsCount {
                label.isHidden = Constant.isPortraitOrientation()
            }
            leading += itemWidth
        }
        return header
    }
    
}

