//
//  SeasonsViewController.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import UIKit

protocol SeasonsViewProtocol: AnyObject {
    func setSeasons(_ seasons: [Season])
}

class SeasonsViewController: UIViewController {

    deinit {
        print(#function, "SeasonsViewController")
    }

    private var presenter: SeasonsPresenterProtocol!
    var id: String!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SeasonsTableViewCell.self, forCellReuseIdentifier: SeasonsTableViewCell.cellId)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        return tableView
    }()
    var tvTrailingAnchor: NSLayoutConstraint?
    var tvLeadingAnchor: NSLayoutConstraint?

    var seasons: [Season] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SeasonsPresenter(view: self)
        presenter.loadData(id: id)
        view.backgroundColor = .white
        setupNavigationBarTitle()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetConstraints()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        resetConstraints()
    }

    private func setupNavigationBarTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Seasons"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
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

extension SeasonsViewController: SeasonsViewProtocol {
    func setSeasons(_ seasons: [Season]) {
        self.seasons = seasons
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
        }
    }
}

extension SeasonsViewController: UITableViewDataSource, UITableViewDelegate {
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
        let vc = StandingsViewController(seasons: seasons, id: id, year: season.year.description)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

