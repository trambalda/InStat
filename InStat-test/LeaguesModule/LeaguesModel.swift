//
//  LeaguesModel.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import Foundation

struct Leagues: Decodable {
    //let status: Bool
    let data: [League]
}

struct League: Decodable {
    let id: String
    let name: String
    //let slug: String
    let abbr: String
    let logos: Logos
}

struct Logos: Decodable {
    let light: String
    //let dark: String
}
