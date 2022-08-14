//
//  Constants.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import UIKit

enum Constant {
    
    static let mainUrl = "https://api-football-standings.azharimm.site"
    static let backgroundColor = UIColor(red: 32/255, green: 112/255, blue: 50/255, alpha: 1)

    static func getBoldFont(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Arial Bold", size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }

    static func getFont(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Arial", size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }

    /*
     Получить размер челки на устройстве, чтобы сделать отступ для контента при просмотре в ландшафте.
     Для устройств без челки отступа не нужно.
     По сути будет либо 44 либо 0.
     */
    static func getInset() -> CGFloat {
        var inset: CGFloat = 0
        if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow }) {
            let insets = window.safeAreaInsets
            if inset < insets.top { inset = insets.top }
            if inset < insets.bottom { inset = insets.bottom }
            if inset < insets.left { inset = insets.left }
            if inset < insets.right { inset = insets.right }
            if inset < 44 { inset = 0 }
        }
        return inset
    }
    
    /*
     Так как внутренняя определялка ориентации периодически возвращает unknown, то определяю сам
     */
    static func isPortraitOrientation() -> Bool {
        let size = UIScreen.main.bounds.size
        return size.width < size.height
//        if size.width < size.height {
//            print("Portrait: \(size.width) X \(size.height)")
//        } else {
//            print("Landscape: \(size.width) X \(size.height)")
//        }
    }
    
    /*
     Константы для настройки количества колонок в портретном и ландшафтном режиме на экране с лигами
     */
    enum Leagues {
        static let columnsPortrait: CGFloat = 2
        static let columnsLandscape: CGFloat = 4
        static let titleHeight: CGFloat = 60
    }
    
    /*
     Константы для корректного вывода таблички на экране со стендингами
     */
    enum Standings {
        static let totalStats = 13
        static let inset: CGFloat = 6
        static let logoSize: CGFloat = 30
        static let nameWidth: CGFloat = 100
        static let teamFieldWidth = 2 * inset + logoSize + inset + nameWidth
        static let itemWidth: CGFloat = 23
        static let itemsCount: Int = {
            let b = UIScreen.main.bounds
            let lesserValue = b.width < b.height ? b.width : b.height
            return Int((lesserValue - teamFieldWidth) / itemWidth)
        }()
    }
}
