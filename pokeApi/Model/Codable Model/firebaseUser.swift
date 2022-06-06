//
//  firebaseUser.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 1/6/22.
//

import Foundation

struct FirebaseUser: Codable {
    let username: String
    let team: [Int]?
    let teamMovementsOriginal: [[String]]?
    
}
