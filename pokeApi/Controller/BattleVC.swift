//
//  BattleVC.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 2/6/22.
//

import UIKit

class BattleVC: UIViewController {
    
    // Barras de Vida de los pokemons
    @IBOutlet weak var enemyActualPokemonHpBar: UIProgressView!
    @IBOutlet weak var userActualPokemonHpBar: UIProgressView!
    
    // Nombres de los pokemons combatiendo
    @IBOutlet weak var enemyActualPokemonName: UILabel!
    @IBOutlet weak var userActualPokemonName: UILabel!
    
    // Imagenes de los pokemons combatiendo
    @IBOutlet weak var enemyActualPokemonImage: UIImageView!
    @IBOutlet weak var userActualPokemonImage: UIImageView!
    
    // Vida actual y máxima del pokemon actual del usuario
    @IBOutlet weak var userActualPokemonMaxHp: UILabel!
    @IBOutlet weak var userActualPokemonCurrentHp: UILabel!
    
    // Campo de texto e imagen de batalla
    @IBOutlet weak var battleTextMessages: UILabel!
    @IBOutlet weak var battleBackgroundImage: UIImageView!
    
    // Imagenes de los ataques del pokemon actual
    @IBOutlet weak var userActualPokemonMoveOneImage: UIImageView!
    @IBOutlet weak var userActualPokemonMoveThreeImage: UIImageView!
    @IBOutlet weak var userActualPokemonMoveTwoImage: UIImageView!
    @IBOutlet weak var userActualPokemonMoveFourImage: UIImageView!
    
    // Nombre de los ataques del pokemon actual
    @IBOutlet weak var userActualPokemonMoveOneName: UILabel!
    @IBOutlet weak var userActualPokemonMoveThreeName: UILabel!
    @IBOutlet weak var userActualPokemonMoveTwoName: UILabel!
    @IBOutlet weak var userActualPokemonMoveFourName: UILabel!
    
    // PPs de los ataques del pokemon actual
    @IBOutlet weak var userActualPokemonMoveOnePP: UILabel!
    @IBOutlet weak var userActualPokemonMoveThreePP: UILabel!
    @IBOutlet weak var userActualPokemonMoveTwoPP: UILabel!
    @IBOutlet weak var userActualPokemonMoveFourPP: UILabel!
    
    // Botones de los ataques del pokemon
    @IBOutlet weak var userActualPokemonMoveOneButtonOutlet: UIButton!
    @IBOutlet weak var userActualPokemonMoveTwoButtonOutlet: UIButton!
    @IBOutlet weak var userActualPokemonMoveThreeButtonOutlet: UIButton!
    @IBOutlet weak var userActualPokemonMoveFourButtonOutlet: UIButton!

    @IBAction func userActualPokemonMoveOneButton(_ sender: Any) {
        print("Pokemon: \(userMoves[userActualPokemonIndex][0].names[0].name)")
        
        userMoves[userActualPokemonIndex][0].currentPP! -= 1
        
        manageBattle(accion: "atacar", indice: 0)
    }
    
    @IBAction func userActualPokemonMoveTwoButton(_ sender: Any) {
        print("Pokemon: \(userMoves[userActualPokemonIndex][1].names[0].name)")
        
        userMoves[userActualPokemonIndex][1].currentPP! -= 1
        
        manageBattle(accion: "atacar", indice: 1)
    }
    
    @IBAction func userActualPokemonMoveThreeButton(_ sender: Any) {
        print("Pokemon: \(userMoves[userActualPokemonIndex][2].names[0].name)")
        
        userMoves[userActualPokemonIndex][2].currentPP! -= 1
        
        manageBattle(accion: "atacar", indice: 2)
    }
    
    @IBAction func userActualPokemonMoveFourButton(_ sender: Any) {
        print("Pokemon: \(userMoves[userActualPokemonIndex][3].names[0].name)")
        
        userMoves[userActualPokemonIndex][3].currentPP! -= 1
        
        manageBattle(accion: "atacar", indice: 3)
    }
    
    // Imagenes de los pokemons del usuario
    @IBOutlet weak var userTeamPokemonOneImage: UIImageView!
    @IBOutlet weak var userTeamPokemonTwoImage: UIImageView!
    @IBOutlet weak var userTeamPokemonThreeImage: UIImageView!
    @IBOutlet weak var userTeamPokemonFourImage: UIImageView!
    @IBOutlet weak var userTeamPokemonFiveImage: UIImageView!
    @IBOutlet weak var userTeamPokemonSixImage: UIImageView!
    
    // Botones de los pokemons del usuario
    @IBOutlet weak var userTeamPokemonOneButtonOutlet: UIButton!
    @IBOutlet weak var userTeamPokemonTwoButtonOutlet: UIButton!
    @IBOutlet weak var userTeamPokemonThreeButtonOutlet: UIButton!
    @IBOutlet weak var userTeamPokemonFourButtonOutlet: UIButton!
    @IBOutlet weak var userTeamPokemonFiveButtonOutlet: UIButton!
    @IBOutlet weak var userTeamPokemonSixButtonOutlet: UIButton!
    
    @IBAction func userTeamPokemonOneButton(_ sender: Any) {
        print("Pokemon: \(userPkms[0].name)")
        
        
        
        cambiarPokemon(indexActualPokemon: 0)
        updateUI()
    }
    
    @IBAction func userTeamPokemonTwoButton(_ sender: Any) {
        print("Pokemon: \(userPkms[1].name)")
        
        cambiarPokemon(indexActualPokemon: 1)
        updateUI()
    }
    
    @IBAction func userTeamPokemonThreeButton(_ sender: Any) {
        print("Pokemon: \(userPkms[2].name)")
        
        cambiarPokemon(indexActualPokemon: 2)
        updateUI()
    }
    
    @IBAction func userTeamPokemonFourButton(_ sender: Any) {
        print("Pokemon: \(userPkms[3].name)")
        
        cambiarPokemon(indexActualPokemon: 3)
        updateUI()
    }
    
    @IBAction func userTeamPokemonFiveButton(_ sender: Any) {
        print("Pokemon: \(userPkms[4].name)")
        
        cambiarPokemon(indexActualPokemon: 4)
        updateUI()
    }
    
    @IBAction func userTeamPokemonSixButton(_ sender: Any) {
        print("Pokemon: \(userPkms[5].name)")
        
        cambiarPokemon(indexActualPokemon: 5)
        updateUI()
    }
    
    var enemyName = ""
    var userName = ""
    var enemyActualPokemonIndex = 0
    var userActualPokemonIndex = 0
    var userPkms = [BattlePokemon]()
    var userMoves = [[DetailedMovement]]()
    var enemyPkms = [BattlePokemon]()
    var enemyMoves = [[DetailedMovement]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Estamos cobatiendo")
        updateUI()
        setPemanentData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        navigationItem.hidesBackButton = true
    
        navigationItem.title = "Combate"
    }
    
    func updateUI() {
        
        // Disable moves by default
        userActualPokemonMoveOneButtonOutlet.isEnabled = false
        userActualPokemonMoveTwoButtonOutlet.isEnabled = false
        userActualPokemonMoveThreeButtonOutlet.isEnabled = false
        userActualPokemonMoveFourButtonOutlet.isEnabled = false
        
        // Las barras de vida se llenan en base a la vida del pokemon
        userActualPokemonHpBar.progress = Float( Float(userPkms[userActualPokemonIndex].currentHp) / Float(userPkms[userActualPokemonIndex].maxHp))
        enemyActualPokemonHpBar.progress = Float( Float(enemyPkms[enemyActualPokemonIndex].currentHp) / Float(enemyPkms[enemyActualPokemonIndex].maxHp))
        
        // Todos los botones de movimientos vacios por defecto
        userActualPokemonMoveTwoPP.text = ""
        userActualPokemonMoveTwoName.text = ""
        userActualPokemonMoveTwoImage.image = UIImage()
        userActualPokemonMoveThreePP.text = ""
        userActualPokemonMoveThreeName.text = ""
        userActualPokemonMoveThreeImage.image = UIImage()
        userActualPokemonMoveFourPP.text = ""
        userActualPokemonMoveFourName.text = ""
        userActualPokemonMoveFourImage.image = UIImage()
        
        // Datos del pokemon actual
        userActualPokemonImage.image = UIImage(data: self.userPkms[userActualPokemonIndex].backImage)
        userActualPokemonMaxHp.text = String(self.userPkms[userActualPokemonIndex].maxHp)
        userActualPokemonCurrentHp.text = String(self.userPkms[userActualPokemonIndex].currentHp)
        userActualPokemonName.text = self.userPkms[userActualPokemonIndex].name.firstUppercased
        
        // Añadir los movimientos en realación a los que tenga el pokemon
        for (index,moves) in self.userMoves[userActualPokemonIndex].enumerated() {
            switch index {
            case 0:
                userActualPokemonMoveOneImage.image = UIImage(named: "battle-\(moves.type.name)")
                userActualPokemonMoveOneName.text = moves.names[0].name
                userActualPokemonMoveOnePP.text = "\(moves.currentPP!)/\(moves.pp)"
                userActualPokemonMoveOneButtonOutlet.isEnabled = true
            case 1:
                userActualPokemonMoveTwoImage.image = UIImage(named: "battle-\(moves.type.name)")
                userActualPokemonMoveTwoName.text = moves.names[0].name
                userActualPokemonMoveTwoPP.text = "\(moves.currentPP!)/\(moves.pp)"
                userActualPokemonMoveTwoButtonOutlet.isEnabled = true
            case 2:
                userActualPokemonMoveThreeImage.image = UIImage(named: "battle-\(moves.type.name)")
                userActualPokemonMoveThreeName.text = moves.names[0].name
                userActualPokemonMoveThreePP.text = "\(moves.currentPP!)/\(moves.pp)"
                userActualPokemonMoveThreeButtonOutlet.isEnabled = true
            default:
                userActualPokemonMoveFourImage.image = UIImage(named: "battle-\(moves.type.name)")
                userActualPokemonMoveFourName.text = moves.names[0].name
                userActualPokemonMoveFourPP.text = "\(moves.currentPP!)/\(moves.pp)"
                userActualPokemonMoveFourButtonOutlet.isEnabled = true
            }
        }
        
        // Datos del pokemon enemigo
        enemyActualPokemonName.text = self.enemyPkms[enemyActualPokemonIndex].name.firstUppercased
        enemyActualPokemonImage.image = UIImage(data: self.enemyPkms[enemyActualPokemonIndex].image )
        
    }
    
    func updateActualPokemonsData() {
        userActualPokemonHpBar.progress = Float( Float(userPkms[userActualPokemonIndex].currentHp) / Float(userPkms[userActualPokemonIndex].maxHp))
        enemyActualPokemonHpBar.progress = Float( Float(enemyPkms[enemyActualPokemonIndex].currentHp) / Float(enemyPkms[enemyActualPokemonIndex].maxHp))
        
        userActualPokemonCurrentHp.text = String(userPkms[userActualPokemonIndex].currentHp)
        
        for (index,moves) in self.userMoves[userActualPokemonIndex].enumerated() {
            switch index {
            case 0:
                userActualPokemonMoveOnePP.text = "\(moves.currentPP!)/\(moves.pp)"
            case 1:
                userActualPokemonMoveTwoPP.text = "\(moves.currentPP!)/\(moves.pp)"
            case 2:
                userActualPokemonMoveThreePP.text = "\(moves.currentPP!)/\(moves.pp)"
            default:
                userActualPokemonMoveFourPP.text = "\(moves.currentPP!)/\(moves.pp)"
            }
        }
        
    }
    
    func setPemanentData() {
        
        // Button zIndex
        userActualPokemonMoveOneButtonOutlet.layer.zPosition = 100
        userActualPokemonMoveTwoButtonOutlet.layer.zPosition = 100
        userActualPokemonMoveThreeButtonOutlet.layer.zPosition = 100
        userActualPokemonMoveFourButtonOutlet.layer.zPosition = 100
        
        // Disabled pokemon buttons by deafult
        userTeamPokemonOneButtonOutlet.isEnabled = false
        userTeamPokemonTwoButtonOutlet.isEnabled = false
        userTeamPokemonThreeButtonOutlet.isEnabled = false
        userTeamPokemonFourButtonOutlet.isEnabled = false
        userTeamPokemonFiveButtonOutlet.isEnabled = false
        userTeamPokemonSixButtonOutlet.isEnabled = false
        
        // Todos los pokemons del equipo vacios por defecto
        userTeamPokemonOneImage.image = UIImage()
        userTeamPokemonTwoImage.image = UIImage()
        userTeamPokemonThreeImage.image = UIImage()
        userTeamPokemonFourImage.image = UIImage()
        userTeamPokemonFiveImage.image = UIImage()
        userTeamPokemonSixImage.image = UIImage()
        
        for (index,pokemon) in self.userPkms.enumerated() {
            switch index {
            case 0:
                userTeamPokemonOneButtonOutlet.isEnabled = true
                userTeamPokemonOneImage.image = UIImage(data: pokemon.image)
            case 1:
                userTeamPokemonTwoButtonOutlet.isEnabled = true
                userTeamPokemonTwoImage.image = UIImage(data: pokemon.image)
            case 2:
                userTeamPokemonThreeButtonOutlet.isEnabled = true
                userTeamPokemonThreeImage.image = UIImage(data: pokemon.image)
            case 3:
                userTeamPokemonFourButtonOutlet.isEnabled = true
                userTeamPokemonFourImage.image = UIImage(data: pokemon.image)
            case 4:
                userTeamPokemonFiveButtonOutlet.isEnabled = true
                userTeamPokemonFiveImage.image = UIImage(data: pokemon.image)
            default:
                userTeamPokemonSixButtonOutlet.isEnabled = true
                userTeamPokemonSixImage.image = UIImage(data: pokemon.image)
            }
        }
        
        // Imagen del campo de combate aleatoria entre 4
        battleBackgroundImage.image = UIImage(named: "background\( Int.random(in: 1...4) )")
    }
    
    // ----- MOST IMPORTANT FUNCTION ----- //
    func manageBattle(accion: String, indice: Int) {
        battleTextMessages.text = ""
        
        switch accion {
        case "atacar":
            print("atacando")
            
            // COmpruebo si es transformacion
            
            if userMoves[userActualPokemonIndex][indice].names[0].name == "Transformación" {
                
                battleTextMessages.text = "\(userPkms[userActualPokemonIndex].name.firstUppercased) usó \(userMoves[userActualPokemonIndex][indice].names[0].name).\n"
                battleTextMessages.text = "\(userPkms[userActualPokemonIndex].name.firstUppercased) copió la apariencia del \(enemyPkms[enemyActualPokemonIndex].name.firstUppercased) rival.\n"
                
                userPkms[userActualPokemonIndex] = enemyPkms[enemyActualPokemonIndex]
                userMoves[userActualPokemonIndex] = enemyMoves[enemyActualPokemonIndex]
                updateUI()
            } else {
                
                // Calculo de daños
                var enemyAttackDmgList = enemyMoves[enemyActualPokemonIndex].map {
                    MovesDmgCalc.shared.calcDmg(attackPkm: enemyPkms[enemyActualPokemonIndex], defensePkm: userPkms[userActualPokemonIndex], move: $0)
                }
                
                var enemyAttackDmg = enemyAttackDmgList.max()!
                var enemyAttackSelectionIndex = enemyAttackDmgList.firstIndex(of: enemyAttackDmg)!
                
                var userAttackDmg = MovesDmgCalc.shared.calcDmg(attackPkm: userPkms[userActualPokemonIndex], defensePkm: enemyPkms[enemyActualPokemonIndex], move: userMoves[userActualPokemonIndex][indice])
                
                // Comprobar quien es más rápido
                if userPkms[userActualPokemonIndex].speed > enemyPkms[enemyActualPokemonIndex].speed {
                    // El usuario ataca
                    enemyPkms[enemyActualPokemonIndex].currentHp = max(enemyPkms[enemyActualPokemonIndex].currentHp - userAttackDmg,0)
                    updateActualPokemonsData()
                    
                    battleTextMessages.text = "\(userPkms[userActualPokemonIndex].name.firstUppercased) usó \(userMoves[userActualPokemonIndex][indice].names[0].name) (\(userAttackDmg) PS).\n"
                    
                    if isCurrentPokemonAlive(who: "enemy") {
                        // El enemigo ataca porque no está muerto
                        userPkms[userActualPokemonIndex].currentHp = max(userPkms[userActualPokemonIndex].currentHp - enemyAttackDmg,0)
                        updateActualPokemonsData()
                        
                        battleTextMessages.text! += "El \(enemyPkms[enemyActualPokemonIndex].name.firstUppercased) enemigo usó \(enemyMoves[enemyActualPokemonIndex][enemyAttackSelectionIndex].names[0].name) (\(enemyAttackDmg) PS).\n"
                        
                        if !isCurrentPokemonAlive(who: "user") {
                            
                            // Esta función saca toda la información del pokemon muerto de pantalla y pone sus imágenes en gris, adeás de desactivar su botón del equipo
                            actualPokemonIsDead()
                            
                            battleTextMessages.text! += "\(userPkms[userActualPokemonIndex].name.firstUppercased) se debilitó.\n"
                            
                            let userPokemonsAlive = userPkms.filter{ $0.currentHp > 0 }.count
                            if userPokemonsAlive == 0 {
                                
                                // ----- DERROTA USER - ALERT AQUI ----- //
                                print("El usuario pierde")
                                battleTextMessages.text! += "\(userName) esta fuera de combate.\n"
                            }
                        }
                        
                    } else {
                        
                        battleTextMessages.text! += "El \(enemyPkms[enemyActualPokemonIndex].name.firstUppercased) enemigo se debilitó.\n"
                        
                        // El enemigo saca a otro pokemon porque el actual está muerto
                        let enemyRandomNewPokemonIndex = enemyPkms.indices.filter { enemyPkms[$0].currentHp > 0 }.randomElement()

                        if (enemyRandomNewPokemonIndex != nil) {
                            // Si aún le quedan pokemons con más de 0 de vida se asigna uno al azar al pokemon actual
                            enemyActualPokemonIndex = enemyRandomNewPokemonIndex!
                            
                            battleTextMessages.text! += "\(enemyName) envió a \(enemyPkms[enemyActualPokemonIndex].name.firstUppercased).\n"
                            
                            enemyActualPokemonImage.image = UIImage(data:enemyPkms[enemyActualPokemonIndex].image)
                            enemyActualPokemonName.text = enemyPkms[enemyActualPokemonIndex].name.firstUppercased
                            enemyActualPokemonHpBar.progress = Float( Float(enemyPkms[enemyActualPokemonIndex].currentHp) / Float(enemyPkms[enemyActualPokemonIndex].maxHp))
                            
                        } else {
                            // Si no le quedan pokemons el usuario gana y se acaba el combate
                            
                            // ----- VICTORIA USER - ALERT AQUI ----- //
                            print("El usuario gana")
                            battleTextMessages.text! += "\(enemyName) esta fuera de combate.\n"
                        }
                        
                    }
                    
                } else {
                    
                    // El enemigo ataca
                    userPkms[userActualPokemonIndex].currentHp = max(userPkms[userActualPokemonIndex].currentHp - enemyAttackDmg,0)
                    updateActualPokemonsData()
                    
                    battleTextMessages.text = "El \(enemyPkms[enemyActualPokemonIndex].name.firstUppercased) enemigo usó \(enemyMoves[enemyActualPokemonIndex][enemyAttackSelectionIndex].names[0].name) (\(enemyAttackDmg) PS).\n"
                    
                    if isCurrentPokemonAlive(who: "user") {
                        // El usuario ataca porque no está muerto
                        enemyPkms[enemyActualPokemonIndex].currentHp = max(enemyPkms[enemyActualPokemonIndex].currentHp - userAttackDmg,0)
                        updateActualPokemonsData()
                        
                        battleTextMessages.text! += "\(userPkms[userActualPokemonIndex].name.firstUppercased) usó \(userMoves[userActualPokemonIndex][indice].names[0].name) (\(userAttackDmg) PS).\n"
                        
                        if !isCurrentPokemonAlive(who: "enemy") {
                            
                            battleTextMessages.text! += "El \(enemyPkms[enemyActualPokemonIndex].name.firstUppercased) enemigo se debilitó.\n"
                            
                            let enemyRandomNewPokemonIndex = enemyPkms.indices.filter { enemyPkms[$0].currentHp > 0 }.randomElement()

                            if (enemyRandomNewPokemonIndex != nil) {
                                // Si aún le quedan pokemons con más de 0 de vida se asigna uno al azar al pokemon actual
                                enemyActualPokemonIndex = enemyRandomNewPokemonIndex!
                                
                                battleTextMessages.text! += "\(enemyName) envió a \(enemyPkms[enemyActualPokemonIndex].name.firstUppercased).\n"
                                
                                enemyActualPokemonImage.image = UIImage(data:enemyPkms[enemyActualPokemonIndex].image)
                                enemyActualPokemonName.text = enemyPkms[enemyActualPokemonIndex].name.firstUppercased
                                enemyActualPokemonHpBar.progress = Float( Float(enemyPkms[enemyActualPokemonIndex].currentHp) / Float(enemyPkms[enemyActualPokemonIndex].maxHp))
                            } else {
                                // Si no le quedan pokemons el usuario gana y se acaba el combate
                                
                                // ----- VICTORIA USER - ALERT AQUI ----- //
                                print("El usuario gana")
                                battleTextMessages.text! += "\(enemyName) esta fuera de combate.\n"
                            }
                        }
                        
                        
                    } else {
                        battleTextMessages.text! += "\(userPkms[userActualPokemonIndex].name.firstUppercased) se debilitó.\n"
                        actualPokemonIsDead()
                        
                        // Se comprueba que el usuario tiene pokemons vivos
                        var userPokemonsAlive = userPkms.filter{ $0.currentHp > 0 }.count
                        if userPokemonsAlive == 0 {
                            
                            // ----- DERROTA USER - ALERT AQUI ----- //
                            print("El usuario pierde")
                            battleTextMessages.text! += "\(userName) esta fuera de combate.\n"
                        }
                        
                    }
            
            }
                
            }
            
        case "cambiar":
            print("cambiando")
            
            
        case "sacar":
            print("sacando")
            
            
        default:
            print("default you should not be here")
        }
        
        
    }
    
    func cambiarPokemon(indexActualPokemon: Int) {
        userActualPokemonIndex = indexActualPokemon
    }
    
    func isCurrentPokemonAlive(who: String) -> Bool {
        if who == "user" {
            return userPkms[userActualPokemonIndex].currentHp > 0
        } else {
            return enemyPkms[enemyActualPokemonIndex].currentHp > 0
        }
    }
    
    func actualPokemonIsDead() {
        
        userActualPokemonImage.image = grayscale(image: userActualPokemonImage.image!)
        
        userActualPokemonHpBar.progress = 0
        userActualPokemonMaxHp.text = ""
        userActualPokemonCurrentHp.text = ""
        userActualPokemonName.text = ""
        
        userActualPokemonMoveOnePP.text = ""
        userActualPokemonMoveOneName.text = ""
        userActualPokemonMoveOneImage.image = UIImage()
        userActualPokemonMoveOneButtonOutlet.isEnabled = false
        
        userActualPokemonMoveTwoPP.text = ""
        userActualPokemonMoveTwoName.text = ""
        userActualPokemonMoveTwoImage.image = UIImage()
        userActualPokemonMoveTwoButtonOutlet.isEnabled = false
        
        userActualPokemonMoveThreePP.text = ""
        userActualPokemonMoveThreeName.text = ""
        userActualPokemonMoveThreeImage.image = UIImage()
        userActualPokemonMoveThreeButtonOutlet.isEnabled = false
        
        userActualPokemonMoveFourPP.text = ""
        userActualPokemonMoveFourName.text = ""
        userActualPokemonMoveFourImage.image = UIImage()
        userActualPokemonMoveFourButtonOutlet.isEnabled = false
        
        switch userActualPokemonIndex {
        case 0:
            userTeamPokemonOneImage.image = grayscale(image: userTeamPokemonOneImage.image!)
            userTeamPokemonOneButtonOutlet.isEnabled = false
        case 1:
            userTeamPokemonTwoImage.image = grayscale(image: userTeamPokemonTwoImage.image!)
            userTeamPokemonTwoButtonOutlet.isEnabled = false
        case 2:
            userTeamPokemonThreeImage.image = grayscale(image: userTeamPokemonThreeImage.image!)
            userTeamPokemonThreeButtonOutlet.isEnabled = false
        case 3:
            userTeamPokemonFourImage.image = grayscale(image: userTeamPokemonFourImage.image!)
            userTeamPokemonFourButtonOutlet.isEnabled = false
        case 4:
            userTeamPokemonFiveImage.image = grayscale(image: userTeamPokemonFiveImage.image!)
            userTeamPokemonFiveButtonOutlet.isEnabled = false
        default:
            userTeamPokemonSixImage.image = grayscale(image: userTeamPokemonSixImage.image!)
            userTeamPokemonSixButtonOutlet.isEnabled = false
        }
        
    }
    
    
    func grayscale(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIPhotoEffectNoir") {
            filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }
    
}
