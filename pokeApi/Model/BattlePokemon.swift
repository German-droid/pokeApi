//
//  BattlePokemon.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 3/6/22.
//

import Foundation

struct BattlePokemon {
    var name: String
    var typeOne: String
    var typeTwo: String
    var maxHp: Int
    var currentHp: Int
    var attack: Int
    var defense: Int
    var spAttack: Int
    var spDefense: Int
    var speed: Int
    
    var image: Data
    var backImage: Data
}
