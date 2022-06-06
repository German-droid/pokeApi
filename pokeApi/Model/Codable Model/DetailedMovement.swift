//
//  DetailedMovement.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 11/5/22.
//

import UIKit

struct DetailedMovement: Codable {
    let name: String
    let accuracy: Int?
    let damage_class: DamageClass
    let type: MoveType
    var names: [MoveNameLang]
    let power: Int?
    let pp: Int
    var currentPP: Int?
}

struct MoveNameLang: Codable {
    let language: MoveLang
    let name: String
}

struct MoveLang: Codable {
    let name: String
}

struct MoveType: Codable {
    let name: String
}

struct DamageClass: Codable {
    let name: String
}
