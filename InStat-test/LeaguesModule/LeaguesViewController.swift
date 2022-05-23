//
//  LeaguesViewController.swift
//  InStat-test
//
//  Created by Денис Рубцов on 20.05.2022.
//

import UIKit

protocol LeaguesViewProtocol: AnyObject {
    func setLeagues(_ leagues: [League])
}

class LeaguesViewController: UIViewController {
    
    deinit {
        print(#function, "LeaguesViewController")
    }
    
    private var presenter: LeaguesPresenterProtocol!

    let horizontalInsets: CGFloat = 24 // спейсинг по горизонтали
    let verticalInsets: CGFloat = 16 // спейсинг по вертикали (2/3 от горизонтали)

    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
        layout.minimumLineSpacing = horizontalInsets
        layout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LeaguesCollectionViewCell.self, forCellWithReuseIdentifier: LeaguesCollectionViewCell.cellId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = Constant.backgroundColor
        return collectionView
    }()
    var cvTrailingAnchor: NSLayoutConstraint?
    var cvLeadingAnchor: NSLayoutConstraint?

    var leagues: [League] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = LeaguesPresenter(view: self)
        presenter.loadData()
        view.backgroundColor = Constant.backgroundColor
        setupNavigationBarTitle()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recalculateView()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        recalculateView()
    }
    
    private func recalculateView() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = getItemSize()
        layout.invalidateLayout()
        resetConstraints()
    }
    
    private func resetConstraints() {
        let inset = Constant.getInset()
        cvLeadingAnchor?.constant = 0
        cvTrailingAnchor?.constant = 0
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            cvLeadingAnchor?.constant = inset
            cvTrailingAnchor?.constant = 0
        case .landscapeRight:
            cvLeadingAnchor?.constant = 0
            cvTrailingAnchor?.constant = -inset
        default:
            break
        }
    }
    
    /*
     Рассчитывает размер ячейки для портрета и ландшафта.
     Можно задать произвольное количество колонок для каждого режима, остальное посчитается само
     */
    private func getItemSize() -> CGSize {
        let b = UIScreen.main.bounds
        let lesserValue = b.width < b.height ? b.width : b.height
        let higherValue = b.width > b.height ? b.width : b.height
        var screenWidth = lesserValue
        var columns: CGFloat = 2
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            columns = 4
            screenWidth = higherValue - Constant.getInset()
        default:
            break
        }
        let itemWidth = (screenWidth - (columns + 1) * horizontalInsets) / columns
        let itemHeight = itemWidth + 60
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    private func setupNavigationBarTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Leagues"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        cvLeadingAnchor = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        cvLeadingAnchor?.isActive = true

        cvTrailingAnchor = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        cvTrailingAnchor?.isActive = true

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}

extension LeaguesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leagues.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LeaguesCollectionViewCell.cellId, for: indexPath) as? LeaguesCollectionViewCell else {
            return LeaguesCollectionViewCell()
        }
        let league = leagues[indexPath.row]
        cell.setup(league: league)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let league = leagues[indexPath.row]
        
        let vc = SeasonsViewController()
        vc.id = league.id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LeaguesViewController: LeaguesViewProtocol {
    func setLeagues(_ leagues: [League]) {
        self.leagues = leagues
        DispatchQueue.main.async { [self] in
            collectionView.reloadData()
        }
    }
}
