//
//  PokemonTeamCell.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 23/5/22.
//

import UIKit
import DropDown

class PokemonTeamCell: UITableViewCell {
    
    var detailedPokemon = DetailedPokemons()
    var pokemonIndexOnTeam = Int()
    var pokemonMovements: [String] = []
    var selectedMovements: [String] = ["-","-","-","-"]
    let dropDown = DropDown()
    
    @IBOutlet weak var pkmIndex: UILabel!
    @IBOutlet weak var pkmName: UILabel!
    @IBOutlet weak var pkmImage: UIImageView!
    @IBOutlet weak var cellBackgroundVIew: UIView!
    @IBOutlet weak var deletePokemon: UIButton!
    
    //Attack 1
    //let pkmAttack1DropDown
    @IBOutlet weak var pkmAttack1View: UIView!
    @IBOutlet weak var pkmAttack1Label: UILabel!
    @IBAction func pkmAttack1Button(_ sender: Any) {
        print("button 1 pressed")
        buttonAction(attackNumber: 1)
    }
    
    //Attack 2
    @IBOutlet weak var pkmAttack2View: UIView!
    @IBOutlet weak var pkmAttack2Label: UILabel!
    @IBAction func pkmAttack2Button(_ sender: Any) {
        print("button 2 pressed")
        buttonAction(attackNumber: 2)
    }
    
    //Attack 3
    @IBOutlet weak var pkmAttack3View: UIView!
    @IBOutlet weak var pkmAttack3Label: UILabel!
    @IBAction func pkmAttack3Button(_ sender: Any) {
        print("button 3 pressed")
        buttonAction(attackNumber: 3)
    }
    
    //Attack 4
    @IBOutlet weak var pkmAttack4View: UIView!
    @IBOutlet weak var pkmAttack4Label: UILabel!
    @IBAction func okmAttack4Button(_ sender: Any) {
        print("button 4 pressed")
        buttonAction(attackNumber: 4)
    }
    
    func setData(pokemon: DetailedPokemons, index: Int) {

        detailedPokemon = pokemon
        pokemonIndexOnTeam = index
        
        if String(pokemon.id).count == 1 {
            pkmIndex.text = "#00\(pokemon.id)"
        } else if String(index).count == 2 {
            pkmIndex.text = "#0\(pokemon.id)"
        } else {
            pkmIndex.text = "#\(pokemon.id)"
        }
        pkmName.text = pokemon.name?.firstUppercased ?? ""
        pkmImage.image = UIImage(data: pokemon.sprite!)
        cellBackgroundVIew.backgroundColor = pkmImage.image?.cropToRect(rect: CGRect(x: 40, y: 40, width: 20, height: 20))?.averageColor
        cellBackgroundVIew.layer.cornerRadius = 20
        pkmAttack1View.layer.cornerRadius = 15
        pkmAttack2View.layer.cornerRadius = 15
        pkmAttack3View.layer.cornerRadius = 15
        pkmAttack4View.layer.cornerRadius = 15
        dropDown.setupCornerRadius(15)
        dropDown.cornerRadius = 15
        
        let arrMovements = pokemon.movements!.allObjects as! [DetailedMovements]
        let sortedMovements = arrMovements.sorted {
            $0.name! < $1.name!
        }.filter({ detailedMovements in
            
            if detailedMovements.name == "Transformación" {
                return true
            } else {
                return detailedMovements.damageClass != "status"
            }
            
        })
        
        var movementsNames = sortedMovements.map {
            $0.name!
        }
        
        if let myTeamMovements = UserDefaults.standard.object(forKey: "myTeamMovements") as? [[String]] {
            let thisPokemonMovements = myTeamMovements[index]
            
            selectedMovements = thisPokemonMovements
            movementsNames = movementsNames.filter {
                !thisPokemonMovements.contains($0)
            }
            
            for (index,movement) in thisPokemonMovements.enumerated() {
                
                switch index {
                case 0:
                    pkmAttack1Label.text = movement
                case 1:
                    pkmAttack2Label.text = movement
                case 2:
                    pkmAttack3Label.text = movement
                default:
                    pkmAttack4Label.text = movement
                }
                
            }
            
        }
        
        pokemonMovements = movementsNames
        pokemonMovements.insert("-", at: 0)
        dropDown.dataSource = pokemonMovements
    }
    
    func buttonAction(attackNumber: Int) {
        dropDown.offsetFromWindowBottom = 100
        dropDown.offsetFromWindowTop = 100
        
        switch attackNumber {
        case 1:
            dropDown.anchorView = pkmAttack1View
        case 2:
            dropDown.anchorView = pkmAttack2View
        case 3:
            dropDown.anchorView = pkmAttack3View
        default:
            dropDown.anchorView = pkmAttack4View
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            switch attackNumber {
            case 1:
                pkmAttack1Label.text = item
            case 2:
                pkmAttack2Label.text = item
            case 3:
                pkmAttack3Label.text = item
            default:
                pkmAttack4Label.text = item
            }
            
            if selectedMovements[attackNumber-1] != "-" {
                print("El movimiento a cambiar es: ",selectedMovements[attackNumber-1])
                pokemonMovements.append( selectedMovements[attackNumber-1] )
                selectedMovements[attackNumber-1] = pokemonMovements.remove(at: index)
            } else {
                selectedMovements[attackNumber-1] = pokemonMovements.remove(at: index)
            }
            
            var sortedMovements = pokemonMovements.sorted {
                $0 < $1
            }
            
            if item == "-" {
                sortedMovements.insert(item, at: 0)
            }

            //print(pokemonIndexOnTeam)
            if var myTeamMovements = UserDefaults.standard.object(forKey: "myTeamMovements") as? [[String]] {
                myTeamMovements[pokemonIndexOnTeam] = selectedMovements
                
                print(myTeamMovements)
                UserDefaults.standard.set(myTeamMovements, forKey: "myTeamMovements")
            }
            
            pokemonMovements = sortedMovements
            dropDown.dataSource = sortedMovements
            
        }
        
        dropDown.show()
    }
    
    
    static let identifier = "PokemonTeamCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PokemonTeamCell", bundle: nil)
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
}
