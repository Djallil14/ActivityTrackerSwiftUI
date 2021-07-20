//
//  Award.swift
//  ActivityTracker
//
//  Created by Djallil Elkebir on 2021-07-19.
//

import Foundation

struct Award: Decodable, Identifiable {
    var id: String { name }
    let name: String
    let description: String
    let color: String
    let criterion: String
    let value: Int
    let image: String
    
    static let allAwards = Bundle.main.decode([Award].self, from: "Awards.json")
    static let example = allAwards[0]
}
