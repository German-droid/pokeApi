//
//  detailedPokemon.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 22/4/22.
//

import Foundation

struct DetailedPokemon: Codable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let sprites: PokemonSprite
    let height: Float
    let weight: Float
    let stats: [PokemonStat]
    let moves: [ResumeMove]
    
}

struct ResumeMove: Codable {
    let move: MoveUrl
}

struct MoveUrl: Codable {
    let url: String
    let name: String
}

struct PokemonSprite: Codable {
    let url: String
    let other: QualitySprite
    
    enum CodingKeys: String, CodingKey {
        case url = "front_default"
        case other = "other"
    }
}

struct QualitySprite: Codable {
    let officialSprite: QualityImage
    
    enum CodingKeys: String, CodingKey {
        case officialSprite = "official-artwork"
    }
}

struct QualityImage: Codable {
    let url: String

    enum CodingKeys: String, CodingKey {
        case url = "front_default"
    }
}


struct PKMType: Codable {
    let name: String
    let url: String

}

struct PokemonType: Codable {
    let slot: Int
    let type: PKMType
}

struct PokemonStat: Codable {
    let value: Int
    let name: PKMStat
    
    enum CodingKeys: String, CodingKey {
        case value = "base_stat"
        case name = "stat"
    }
}

struct PKMStat: Codable {
    let name: String
}

