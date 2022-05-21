//
//  LeaguesCollectionViewCell.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import UIKit

class LeaguesCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "LeaguesCell"
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        return separator
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = Constant.getBoldFont(size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(league: League) {
        nameLabel.text = "\(league.name) (\(league.abbr))"
        nameLabel.sizeToFit()
        if let url = URL(string: league.logos.light) {
            NetworkService.shared.loadImage(with: url) { [self] result in
                switch result {
                case .success(let image):
                    logoImageView.image = image
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor),
        ])

        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])

        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 3),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
        ])
    }
}
