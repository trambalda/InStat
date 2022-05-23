//
//  LeaguesView.swift
//  InStat-test
//
//  Created by Денис Рубцов on 23.05.2022.
//

import UIKit

class LeaguesView: UICollectionView {
    
    var presenter: LeaguesPresenterProtocol?
    
    let horizontalInsets: CGFloat = 24 // спейсинг по горизонтали
    let verticalInsets: CGFloat = 16 // спейсинг по вертикали (2/3 от горизонтали)

    var leagues: [League] = []
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
        layout.minimumLineSpacing = horizontalInsets
        layout.minimumInteritemSpacing = 0

        super.init(frame: .zero, collectionViewLayout: layout)
        dataSource = self
        delegate = self
        register(LeaguesCollectionViewCell.self, forCellWithReuseIdentifier: LeaguesCollectionViewCell.cellId)
        showsVerticalScrollIndicator = false
        backgroundColor = Constant.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LeaguesView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leagues.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LeaguesCollectionViewCell.cellId, for: indexPath) as? LeaguesCollectionViewCell else {
            return LeaguesCollectionViewCell()
        }
        let league = leagues[indexPath.row]
        cell.setup(league: league)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let league = leagues[indexPath.row]
        presenter?.showSeasonScreen(leagueId: league.id)
    }
    
}

extension LeaguesView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getItemSize()
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
        var columns: CGFloat = Constant.Leagues.columnsPortrait
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            columns = Constant.Leagues.columnsLandscape
            screenWidth = higherValue - Constant.getInset()
        default:
            break
        }
        let itemWidth = (screenWidth - (columns + 1) * horizontalInsets) / columns
        let itemHeight = itemWidth + Constant.Leagues.titleHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
