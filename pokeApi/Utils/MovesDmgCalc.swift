//
//  MovesDmgCalc.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 4/6/22.
//

import Foundation

class MovesDmgCalc {
    
    static let shared = MovesDmgCalc()
    
    func calcDmg(attackPkm: BattlePokemon, defensePkm: BattlePokemon, move: DetailedMovement) -> Int {
        
        let isPhysical = move.damage_class.name == "physical"
        let level = 100
        
        let calcDetails = 0.01 * Double( move.type.name == attackPkm.typeOne || move.type.name == attackPkm.typeTwo ? 1.5 : 1.0 ) * typeDmgMultiplier(attackType: move.type.name, defenseType1: defensePkm.typeOne, defenseType2: defensePkm.typeTwo) * Double(Int.random(in: 85...100 ))
        
        let calcParentesis = 0.2 * Double(level) + 1
        
        let calcNoParentesis = Double( isPhysical ? attackPkm.attack : attackPkm.spAttack) * Double(move.power ?? 0)
        
        let calcBajoDivision = Double(25 * Double(isPhysical ? defensePkm.defense : defensePkm.spDefense))
        
        
        var calcFinal = calcParentesis * calcNoParentesis
        calcFinal = calcFinal / calcBajoDivision
        calcFinal = calcFinal + 2
        calcFinal = calcDetails * calcFinal
        
        return Int(calcFinal)
    }
    
    func typeDmgMultiplier(attackType: String, defenseType1: String, defenseType2: String ) -> Double {
    
    var modifier = 1.0
    
    let types = [defenseType1, defenseType2]
    
    switch attackType {
    case "normal":
        for type in types {
            switch type {
            case "rock": modifier/=2
            case "ghost": modifier = 0
            case "steel": modifier/=2
            default: break
            }
        }
        break
    case "fire":
        for type in types {
            switch type {
            case "fire": modifier/=2
            case "water": modifier/=2
            case "grass": modifier*=2
            case "ice": modifier*=2
            case "bug": modifier*=2
            case "rock": modifier/=2
            case "dragon": modifier/=2
            case "steel": modifier*=2
            default: break
            }
        }
        break
    case "water":
        for type in types {
            switch type {
            case "fire": modifier*=2
            case "water": modifier/=2
            case "grass": modifier/=2
            case "ground": modifier*=2
            case "rock": modifier*=2
            case "dragon": modifier/=2
            default: break
            }
        }
        break
    case "grass":
        for type in types {
            switch type {
            case "fire": modifier/=2
            case "water": modifier*=2
            case "grass": modifier/=2
            case "poison": modifier/=2
            case "ground": modifier*=2
            case "flying": modifier/=2
            case "bug": modifier/=2
            case "rock": modifier*=2
            case "dragon": modifier/=2
            case "steel": modifier/=2
            default: break
            }
        }
        break
    case "electric":
        for type in types {
            switch type {
            case "water": modifier*=2
            case "grass": modifier/=2
            case "electric": modifier/=2
            case "ground": modifier = 0
            case "flying": modifier*=2
            case "dragon": modifier/=2
            default: break
            }
        }
        break
    case "ice":
        for type in types {
            switch type {
            case "fire": modifier/=2
            case "water": modifier/=2
            case "grass": modifier*=2
            case "ice": modifier/=2
            case "ground": modifier*=2
            case "flying": modifier*=2
            case "dragon": modifier*=2
            case "steel": modifier/=2
            default: break
            }
        }
        break
    case "fighting":
        for type in types {
            switch type {
            case "normal": modifier*=2
            case "ice": modifier*=2
            case "poison": modifier/=2
            case "flying": modifier/=2
            case "psychic": modifier/=2
            case "bug": modifier/=2
            case "rock": modifier*=2
            case "ghost": modifier = 0
            case "dark": modifier*=2
            case "steel": modifier*=2
            case "fairy": modifier/=2
            default: break
            }
        }
        break
    case "poison":
        for type in types {
            switch type {
            case "grass": modifier*=2
            case "poison": modifier/=2
            case "ground": modifier/=2
            case "rock": modifier/=2
            case "ghost": modifier/=2
            case "steel": modifier = 0
            case "fairy": modifier*=2
            default: break
            }
        }
        break
    case "ground":
        for type in types {
            switch type {
            case "fire": modifier*=2
            case "grass": modifier/=2
            case "electric": modifier*=2
            case "poison": modifier*=2
            case "flying": modifier = 0
            case "bug": modifier/=2
            case "rock": modifier*=2
            case "steel": modifier*=2
            default: break
            }
        }
        break
    case "flying":
        for type in types {
            switch type {
            case "grass": modifier*=2
            case "electric": modifier/=2
            case "fighting": modifier*=2
            case "bug": modifier*=2
            case "rock": modifier/=2
            case "steel": modifier/=2
            default: break
            }
        }
        break
    case "psychic":
        for type in types {
            switch type {
            case "fighting": modifier*=2
            case "poison": modifier*=2
            case "psychic": modifier/=2
            case "dark": modifier = 0
            case "steel": modifier/=2
            default: break
            }
        }
        break
    case "bug":
        for type in types {
            switch type {
            case "fire": modifier/=2
            case "grass": modifier*=2
            case "fighting": modifier/=2
            case "poison": modifier/=2
            case "flying": modifier/=2
            case "psychic": modifier*=2
            case "ghost": modifier/=2
            case "dark": modifier*=2
            case "steel": modifier/=2
            case "fairy": modifier/=2
            default: break
            }
        }
        break
    case "rock":
        for type in types {
            switch type {
            case "fire": modifier*=2
            case "ice": modifier*=2
            case "fighting": modifier/=2
            case "ground": modifier/=2
            case "flying": modifier*=2
            case "bug": modifier*=2
            case "steel": modifier/=2
            default: break
            }
        }
        break
    case "ghost":
        for type in types {
            switch type {
            case "normal": modifier = 0
            case "psychic": modifier*=2
            case "ghost": modifier*=2
            case "dark": modifier/=2
            case "steel": modifier/=2
            default: break
            }
        }
        break
    case "dragon":
        for type in types {
            switch type {
            case "dragon": modifier*=2
            case "steel": modifier/=2
            case "fairy": modifier = 0
            default: break
            }
        }
        break
    case "dark":
        for type in types {
            switch type {
            case "fighting": modifier/=2
            case "psychic": modifier*=2
            case "ghost": modifier*=2
            case "dark": modifier/=2
            case "steel": modifier/=2
            case "fairy": modifier/=2
            default: break
            }
        }
        break
    case "steel":
        for type in types {
            switch type {
            case "fire": modifier/=2
            case "water": modifier/=2
            case "ice": modifier*=2
            case "rock": modifier*=2
            case "steel": modifier/=2
            case "fairy": modifier*=2
            default: break
            }
        }
        break
    case "fairy":
        for type in types {
            switch type {
            case "fire": modifier/=2
            case "fighting": modifier*=2
            case "poison": modifier/=2
            case "dragon": modifier*=2
            case "dark": modifier*=2
            case "steel": modifier/=2
            default: break
            }
        }
        break
    default:
        print("error")
    }
    
    return modifier
}
    
}
