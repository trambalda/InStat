//
//  StandingsModel.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import Foundation

struct LeagueStandings: Decodable {
    let status: Bool
    let data: Standings
}

struct Standings: Decodable {
    let name: String
    let abbreviation: String
    let seasonDisplay: String
    let season: Int
    let standings: [Standing]
}

struct Standing: Decodable {
    let team: Team
    let note: Note?
    let stats: [Stat]
}

struct Team: Decodable {
    let id: String
    let uid: String
    let location: String
    let name: String
    let abbreviation: String
    let displayName: String
    let shortDisplayName: String
    let isActive: Bool
    let logos: [StandingsLogos]?
}

struct StandingsLogos: Decodable {
    let href: String
    let width: Int
    let height: Int
    let alt: String
    let rel: [String]
    let lastUpdated: String
}

struct Note: Decodable {
    let color: String
    let description: String
    let rank: Int
}

struct Stat: Decodable {
    let name: String
    let displayName: String
    let shortDisplayName: String
    let description: String
    let abbreviation: String
    let type: String
    let value: Int?
    let displayValue: String
}
