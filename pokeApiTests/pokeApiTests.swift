//
//  pokeApiTests.swift
//  pokeApiTests
//
//  Created by German Fuentes Ripoll on 4/4/22.
//

import XCTest
@testable import pokeApi

class pokeApiTests: XCTestCase {


    func testDmg1() {
        let result = MovesDmgCalc.shared.typeDmgMultiplier(attackType: "dragon", defenseType1: "fairy", defenseType2: "dragon")

        XCTAssertEqual(result,0)
    }
    
    func testDmg2() {
        let result = MovesDmgCalc.shared.typeDmgMultiplier(attackType: "fire", defenseType1: "water", defenseType2: "ghost")

        XCTAssertEqual(result,0.5)
    }
    
    func testDmg3() {
        let result = MovesDmgCalc.shared.typeDmgMultiplier(attackType: "bug", defenseType1: "grass", defenseType2: "dark")

        XCTAssertEqual(result,4)
    }
    
    func testDmg4() {
        let result = MovesDmgCalc.shared.typeDmgMultiplier(attackType: "steel", defenseType1: "rock", defenseType2: "steel")

        XCTAssertEqual(result,0.5)
    }
    
    func testDmg5() {
        let result = MovesDmgCalc.shared.typeDmgMultiplier(attackType: "electric", defenseType1: "water", defenseType2: "ground")

        XCTAssertEqual(result,0.25)
    }
    
    func testDmg6() {
        let result = MovesDmgCalc.shared.typeDmgMultiplier(attackType: "fighting", defenseType1: "normal", defenseType2: "water")

        XCTAssertEqual(result,2)
    }
    
    
}
