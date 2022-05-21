//
//  StandingsTableViewCell.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import UIKit

class StandingsTableViewCell: UITableViewCell {
    
    static let cellId = "cellId"
    var nameWidthConstraint: NSLayoutConstraint?
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.font = Constant.getBoldFont(size: 13)
        return label
    }()
    
    lazy var statLabels: [UILabel] = {
        var labels: [UILabel] = []
        for _ in 0..<Constant.Standings.totalStats {
            let label = UILabel()
            label.textColor = .black
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = Constant.getFont(size: 14)
            labels.append(label)
        }
        return labels
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(standing: Standing) {
        if let logos = standing.team.logos {
            if let url = URL(string: logos[0].href) {
                NetworkService.shared.loadImage(with: url) { [self] result in
                    switch result {
                    case .success(let image):
                        logoImageView.image = image
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }

        nameLabel.text = standing.team.displayName
        nameLabel.sizeToFit()

        let isPortraitOrientation = Constant.isPortraitOrientation()
        
        for i in 0..<Constant.Standings.totalStats {
            statLabels[i].text = standing.stats[i].displayValue
            if i >= Constant.Standings.itemsCount {
                statLabels[i].isHidden = isPortraitOrientation
            }
        }
        
        var nameWidth = Constant.Standings.nameWidth
        if isPortraitOrientation == false {
            nameWidth *= 2
        }
        nameWidthConstraint?.constant = nameWidth
    }
    
    private func setupConstraints() {
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Standings.inset * 2),
            logoImageView.widthAnchor.constraint(equalToConstant: Constant.Standings.logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: Constant.Standings.logoSize),
        ])
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: Constant.Standings.inset),
        ])
        nameWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: Constant.Standings.nameWidth)
        nameWidthConstraint?.isActive = true
        
        var leading = Constant.Standings.inset
        for i in 0..<Constant.Standings.totalStats {
            var itemWidth = Constant.Standings.itemWidth
            if i >= Constant.Standings.totalStats - 4 { itemWidth *= 1.5 }
            if i >= Constant.Standings.totalStats - 1 { itemWidth += itemWidth }
            addSubview(statLabels[i])
            statLabels[i].translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                statLabels[i].centerYAnchor.constraint(equalTo: centerYAnchor),
                statLabels[i].leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: leading),
                statLabels[i].widthAnchor.constraint(equalToConstant: itemWidth),
            ])
            leading += itemWidth
        }
    }

}

