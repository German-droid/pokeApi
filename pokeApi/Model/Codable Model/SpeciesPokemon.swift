//
//  SpeciesPokemon.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 11/5/22.
//

import UIKit

struct SpeciesPokemon: Codable {
    let capture_rate: Int
    let genera: [Genera]
    let flavor_text_entries: [FlavorText]
    
}

struct Genera: Codable {
    let genus: String
}

struct FlavorText: Codable {
    let flavor_text: String
    let language: Language
    let version: Juego

}

struct Language: Codable {
    let name: String
}

struct Juego: Codable {
    let name: String
}
