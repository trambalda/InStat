//
//  StandingsViewController.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import UIKit

protocol StandingsViewProtocol: AnyObject {
    func setStandings(_ standings: [Standing])
}

protocol StandingsViewDelegate {
    func changeSeason(to newYear: Int)
}

class StandingsViewController: UIViewController {

    private var presenter: StandingsPresenterProtocol!
    var id: String!
    var year: String! {
        didSet {
            print("didset")
            setNavigationTitle()
        }
    }
    var seasons: [Season] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StandingsTableViewCell.self, forCellReuseIdentifier: StandingsTableViewCell.cellId)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    var tvTrailingAnchor: NSLayoutConstraint?
    var tvLeadingAnchor: NSLayoutConstraint?

    var standings: [Standing] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = StandingsPresenter(view: self)
        presenter.loadData(id: id, year: year)
        view.backgroundColor = Constant.backgroundColor
        setupNavigationBar()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetConstraints()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        resetConstraints()
        tableView.reloadData()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constant.backgroundColor
        appearance.shadowColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        setNavigationTitle()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(changeSeasonButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func setNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Standings \(year ?? "")"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
    }

    @objc func changeSeasonButtonTapped() {
        let vc = SelectViewController(seasons: seasons, delegate: self)
        present(vc, animated: true)
    }

    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    private func resetConstraints() {
        let inset = Constant.getInset()
        tvLeadingAnchor?.constant = 0
        tvTrailingAnchor?.constant = 0
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            tvLeadingAnchor?.constant = inset
            tvTrailingAnchor?.constant = 0
        case .landscapeRight:
            tvLeadingAnchor?.constant = 0
            tvTrailingAnchor?.constant = -inset
        default:
            break
        }
    }

    private func setupConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tvLeadingAnchor = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        tvLeadingAnchor?.isActive = true

        tvTrailingAnchor = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        tvTrailingAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension StandingsViewController: StandingsViewProtocol {
    func setStandings(_ standings: [Standing]) {
        self.standings = standings
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
        }
    }
}

extension StandingsViewController: StandingsViewDelegate {
    public func changeSeason(to newYear: Int) {
        year = newYear.description
        presenter.loadData(id: id, year: year)
    }
}

extension StandingsViewController: UITableViewDataSource, UITableViewDelegate {
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

