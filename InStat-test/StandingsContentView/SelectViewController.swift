//
//  SelectViewController.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import UIKit

protocol SelectViewProtocol {
    var delegate: SelectViewDelegateProtocol? { get set }
}

class SelectViewController: UITableViewController, SelectViewProtocol {

    let cellId = "CellId"
    var seasons: [Season]!
    var delegate: SelectViewDelegateProtocol?

    init(seasons: [Season], delegate: SelectViewDelegateProtocol) {
        self.seasons = seasons
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let season = seasons[indexPath.row]
        cell.textLabel?.text = season.displayName
        cell.textLabel?.font = Constant.getBoldFont(size: 14)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedYear = seasons[indexPath.row].year
        delegate?.changeSeason(to: selectedYear.description)
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = Constant.backgroundColor
        
        let nameLabel = UILabel()
        nameLabel.text = "Choose a season"
        nameLabel.font = Constant.getBoldFont(size: 18)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        
        header.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor),
        ])
        return header
    }
}
