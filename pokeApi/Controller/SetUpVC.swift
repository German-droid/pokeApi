//
//  BattleVC.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 5/4/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import DropDown

class SetUpVC: UIViewController {
    
    //User pokemons
    @IBOutlet weak var userPkm1: UIImageView!
    @IBOutlet weak var userPkm2: UIImageView!
    @IBOutlet weak var userPkm3: UIImageView!
    @IBOutlet weak var userPkm4: UIImageView!
    @IBOutlet weak var userPkm5: UIImageView!
    @IBOutlet weak var userPkm6: UIImageView!

    //Enemy pokemons
    @IBOutlet weak var enemyPkm1: UIImageView!
    @IBOutlet weak var enemyPkm2: UIImageView!
    @IBOutlet weak var enemyPkm3: UIImageView!
    @IBOutlet weak var enemyPkm4: UIImageView!
    @IBOutlet weak var enemyPkm5: UIImageView!
    @IBOutlet weak var enemyPkm6: UIImageView!
    
    
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var dropdownLabel: UILabel!

    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var labelEnemy: UILabel!
    @IBOutlet weak var fightView: UIView!
    
    @IBOutlet weak var backgroundEnemy: UIImageView!
    @IBOutlet weak var backgroundUser: UIImageView!
    
    @IBOutlet weak var startFightButton: UIButton!
    @IBAction func startFight(_ sender: Any) {
        print("A combatir")
        
        guard enemyname != "" else {
            CustomToast.show(message: "Debes de seleccionar un rival", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
            return
        }
        
        guard username != "" else {
            CustomToast.show(message: "Debes de tener un equipo", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
            return
        }
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let battleViewController = storyBoard.instantiateViewController(withIdentifier: "battleVC") as! BattleVC
        battleViewController.userName = username
        battleViewController.enemyName = enemyname
        battleViewController.userPkms = selectedPkmsBattle
        battleViewController.userMoves = selectedMovementsDetailed
        battleViewController.enemyPkms = enemyPkmsBattle
        battleViewController.enemyMoves = enemyMovementsDetailed
        navigationController?.pushViewController(battleViewController, animated: true)
        
        
        
    }
    
    @IBAction func dropdownButtonAction(_ sender: Any) {
        
        getUsersData()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        
            print("Clicked \(item) to fight against!")
            let userSelected = enemyTrainers[index]

            enemyname = item
            enemyPkms = self.checkForPokemons(myTeam: userSelected.team!)
            enemyPkmsBattle = self.calcPokemonStatsForBattle(myTeam: enemyPkms)
            
            enemyMovements = userSelected.teamMovementsOriginal!
            
            var detailedMove: DetailedMovement? = nil
            
            for (index,pkmMoves) in userSelected.teamMovementsOriginal!.enumerated() {
                
                enemyMovementsDetailed.insert([], at: index)
                            
                for move in pkmMoves {
                    var maxPP = 0
                    
                    if move != "-" {
                        Service.shared.fetchOneMove(url: "https://pokeapi.co/api/v2/move/\(move)", completion: { detailedMovement in
                            guard var detailedMove = detailedMovement as? DetailedMovement else {
                                return
                            }
                            detailedMove.names = detailedMove.names.filter {
                                $0.language.name == "es"
                            }
                            maxPP = detailedMove.pp
                            detailedMove.currentPP = maxPP
                            self.enemyMovementsDetailed[index].append(detailedMove)
                        })
                    }
                    
                }
                
            }
            
            setDataPokemonsEnemy()
            
        }
        
        
    }
    
    var enemyname = ""
    var username = ""
    var selectedPkms = [DetailedPokemons]()
    var selectedPkmsBattle = [BattlePokemon]()
    var selectedMovements = [[String]]()
    var selectedMovementsDetailed = [[DetailedMovement]]()
    
    var enemyPkms = [DetailedPokemons]()
    var enemyPkmsBattle = [BattlePokemon]()
    var enemyMovements = [[String]]()
    var enemyMovementsDetailed = [[DetailedMovement]]()
    
    var enemyTrainers = [FirebaseUser]()
    var enemyUsernames = [String]()
    let dropDown = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        dropDown.offsetFromWindowBottom = 100
        dropDown.offsetFromWindowTop = 100
        dropDown.setupCornerRadius(10)
        dropDown.cornerRadius = 10
        dropDown.anchorView = dropdownView
        
        backgroundEnemy.layer.cornerRadius = 20
        backgroundUser.layer.cornerRadius = 20
        dropdownView.layer.cornerRadius = 10
        fightView.layer.cornerRadius = 10
        
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = .mainPink()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 35)!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.title = "Preparación"
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startFightButton.isEnabled = false
        downloadPokemons()
        
        
        
    }
    
    func downloadPokemons() {
        
        userPkm1.image = UIImage()
        userPkm2.image = UIImage()
        userPkm3.image = UIImage()
        userPkm4.image = UIImage()
        userPkm5.image = UIImage()
        userPkm6.image = UIImage()
        
        guard let user = Auth.auth().currentUser else {return}
            
        Database.database().reference().child("usuarios").child(user.uid).observeSingleEvent(of: .value) { snapshot in
            guard let team = snapshot.childSnapshot(forPath: "team").value as? [Int], let teamMovementsOriginal = snapshot.childSnapshot(forPath: "teamMovementsOriginal").value as? [[String]], let username = snapshot.childSnapshot(forPath: "username").value as? String else {
                CustomToast.show(message: "No se tienen datos guardados", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                
                return
            }
            //print(team,teamMovements)
            
            guard team.count != 0 || teamMovementsOriginal.count != 0 else {
                CustomToast.show(message: "No se tienen datos guardados", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                return
            }
            
            self.username = username
            self.startFightButton.isEnabled = true
            self.selectedPkms = self.checkForPokemons(myTeam: team)
            self.selectedPkmsBattle = self.calcPokemonStatsForBattle(myTeam: self.selectedPkms)
            
            self.setDataPokemonsUser()
            self.selectedMovements = teamMovementsOriginal
            
            var detailedMove: DetailedMovement? = nil
            
            for (index,pkmMoves) in teamMovementsOriginal.enumerated() {
                
                self.selectedMovementsDetailed.insert([], at: index)
                
                for move in pkmMoves {
                    var maxPP = 0
                    if move != "-" {
                        Service.shared.fetchOneMove(url: "https://pokeapi.co/api/v2/move/\(move)", completion: { detailedMovement in
                            guard var detailedMove = detailedMovement as? DetailedMovement else {
                                return
                            }
                            detailedMove.names = detailedMove.names.filter {
                                $0.language.name == "es"
                            }
                            maxPP = detailedMove.pp
                            detailedMove.currentPP = maxPP
                            self.selectedMovementsDetailed[index].append(detailedMove)
                        })
                    }
                    
                }
            }
            
        }
    }
    
    func checkForPokemons(myTeam: [Int]) -> [DetailedPokemons] {
        var selectedNow = [DetailedPokemons]()
                
        for pokemonID in myTeam {
            Service.shared.fetchOneFromCoreData(id: pokemonID) { detailedPokemon in
                selectedNow.append(detailedPokemon)
            }
                    
        }
        return selectedNow
        
    }
    
    func calcPokemonStatsForBattle(myTeam: [DetailedPokemons]) -> [BattlePokemon] {
        var selectedNow = [BattlePokemon]()
                
        for detailedPokemon in myTeam {
            
            var name = detailedPokemon.name!
            var image = detailedPokemon.sprite!
            var backImage = detailedPokemon.backSprite!
            
            var result = 2 * Int(detailedPokemon.stats!.hp) + 0 + Int(floor(0.25 * 0))
            var maxHP = Int(floor(0.01 * Double(result) * 100)) + 100 + 10
            var currentHP = maxHP
            
            result = 2 * Int(detailedPokemon.stats!.attack) + 0 + Int(floor(0.25 * 0))
            var attack = Int(floor(0.01 * Double(result) * 100)) + 5
            
            result = 2 * Int(detailedPokemon.stats!.defense) + 0 + Int(floor(0.25 * 0))
            var defense = Int(floor(0.01 * Double(result) * 100)) + 5

            result = 2 * Int(detailedPokemon.stats!.specialAttack) + 0 + Int(floor(0.25 * 0))
            var spAttack = Int(floor(0.01 * Double(result) * 100)) + 5
            
            result = 2 * Int(detailedPokemon.stats!.specialDefense) + 0 + Int(floor(0.25 * 0))
            var spDefense = Int(floor(0.01 * Double(result) * 100)) + 5
            
            result = 2 * Int(detailedPokemon.stats!.speed) + 0 + Int(floor(0.25 * 0))
            var speed = Int(floor(0.01 * Double(result) * 100)) + 5
            
            var typeOne = "", typeTwo = ""
            
            for pkmtype in detailedPokemon.types! as! Set<Types> {
                if (pkmtype.slot == 1) {
                    typeOne = pkmtype.name ?? ""
                } else {
                    typeTwo = pkmtype.name ?? ""
                }
            }
            
            var newBattlePokemon = BattlePokemon(name: name, typeOne: typeOne, typeTwo: typeTwo, maxHp: maxHP, currentHp: currentHP, attack: attack, defense: defense, spAttack: spAttack, spDefense: spDefense, speed: speed, image: image, backImage: backImage)
                   
            selectedNow.append(newBattlePokemon)
        }
        return selectedNow
        
    }
    
    func setDataPokemonsUser() {
        
        self.labelUser.text = username
        
        for (index,pokemon) in selectedPkms.enumerated() {
            switch index {
            case 0:
                userPkm1.image = UIImage(data: pokemon.sprite!)
            case 1:
                userPkm2.image = UIImage(data: pokemon.sprite!)
            case 2:
                userPkm3.image = UIImage(data: pokemon.sprite!)
            case 3:
                userPkm4.image = UIImage(data: pokemon.sprite!)
            case 4:
                userPkm5.image = UIImage(data: pokemon.sprite!)
            default:
                userPkm6.image = UIImage(data: pokemon.sprite!)
            }
        }
        
    }
    
    func setDataPokemonsEnemy() {
        
        self.dropdownLabel.text = enemyname
        self.labelEnemy.text = enemyname
        
        enemyPkm1.image = UIImage()
        enemyPkm2.image = UIImage()
        enemyPkm3.image = UIImage()
        enemyPkm4.image = UIImage()
        enemyPkm5.image = UIImage()
        enemyPkm6.image = UIImage()
        
        for (index,pokemon) in enemyPkms.enumerated() {
            switch index {
            case 0:
                enemyPkm1.image = UIImage(data: pokemon.sprite!)
            case 1:
                enemyPkm2.image = UIImage(data: pokemon.sprite!)
            case 2:
                enemyPkm3.image = UIImage(data: pokemon.sprite!)
            case 3:
                enemyPkm4.image = UIImage(data: pokemon.sprite!)
            case 4:
                enemyPkm5.image = UIImage(data: pokemon.sprite!)
            default:
                enemyPkm6.image = UIImage(data: pokemon.sprite!)
            }
        }
        
    }
    
    func getUsersData() {

        guard let user = Auth.auth().currentUser else {return}
        
        var currentUsers = [FirebaseUser]()
        var usernames = [String]()
            
        Database.database().reference().child("usuarios").observeSingleEvent(of: .value) { [self] snapshot in
         
            let json = snapshot.value as! [String: Any]
            
            for (key,user) in json {
                
                do {
                    let cleanUser = try JSONSerialization.data(withJSONObject: user)
                    let firUser = try JSONDecoder().decode(FirebaseUser.self, from: cleanUser)

                    if firUser.team != nil {
                        
                        if firUser.username == username {
                            usernames.append("Rival Espejo")
                        } else {
                            usernames.append(firUser.username)
                        }
                    
                        currentUsers.append(firUser)
                    }
                    
                    } catch {
                      print("an error occurred", error)
                    }
                
            }
            
            self.enemyUsernames = usernames
            self.enemyTrainers = currentUsers
            dropDown.dataSource = self.enemyUsernames
            dropDown.show()
        }
        
    }
    
}
