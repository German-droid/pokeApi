//
//  SecondVC.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 4/4/22.
//

import Foundation
import UIKit
import OrderedCollections
import FirebaseAuth
import FirebaseDatabase

class TeamVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    public var noTeamLabel: UILabel = {
        let label = UILabel()
        label.text = "Es necesario seleccionar al menos 1 pokemon"
        label.textAlignment = .center
        label.font = UIFont(name: "Puzzle-Tale-Pixel", size: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 190
        table.allowsSelection = false
        table.isUserInteractionEnabled = true
        //table.separatorColor = .mainPink()
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.register(PokemonTeamCell.nib(), forCellReuseIdentifier: PokemonTeamCell.identifier)
        return table
    }()
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedPkms = [DetailedPokemons]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        downloadYourTeam()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        configOnce()
        
        view.addSubview(noTeamLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            noTeamLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            noTeamLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkForPokemons()

    }
    
    func checkForPokemons() {
        if let myTeam = UserDefaults.standard.object(forKey: "myTeam") as? [Int] {
            if myTeam.count >= 1 {
                
                var selectedNow = [DetailedPokemons]()
                
                noTeamLabel.isHidden = true
                
                for pokemonID in myTeam {
                    Service.shared.fetchOneFromCoreData(id: pokemonID) { detailedPokemon in
                        selectedNow.append(detailedPokemon)
                    }
                    
                }
                selectedPkms = selectedNow
                
                if var myTeamMovements = UserDefaults.standard.object(forKey: "myTeamMovements") as? [[String]] {
                    // El resto de veces se comprueba que hayan el mismo numero de pokemons que de movimientos de uno, sino se añaden nuevos vacios
                    let diff = selectedPkms.count - myTeamMovements.count
                    
                    if diff != 0 {
                        for _ in 1...diff {
                            myTeamMovements.append(["-","-","-","-"])
                        }
                        UserDefaults.standard.set(myTeamMovements, forKey: "myTeamMovements")
                    }
                    
                } else {
                    // Primera vez que entras
                    var myTeamMovements: [[String]] = []
                    
                    for _ in selectedNow {
                        myTeamMovements.append(["-","-","-","-"])
                    }
                    UserDefaults.standard.set(myTeamMovements, forKey: "myTeamMovements")
                    
                }
                
                if var myTeamMovementsOriginal = UserDefaults.standard.object(forKey: "myTeamMovementsOriginal") as? [[String]] {
                    // El resto de veces se comprueba que hayan el mismo numero de pokemons que de movimientos de uno, sino se añaden nuevos vacios
                    let diff = selectedPkms.count - myTeamMovementsOriginal.count
                    
                    if diff != 0 {
                        for _ in 1...diff {
                            myTeamMovementsOriginal.append(["-","-","-","-"])
                        }
                        UserDefaults.standard.set(myTeamMovementsOriginal, forKey: "myTeamMovementsOriginal")
                    }
                    
                } else {
                    // Primera vez que entras
                    var myTeamMovementsOriginal: [[String]] = []
                    
                    for _ in selectedNow {
                        myTeamMovementsOriginal.append(["-","-","-","-"])
                    }
                    UserDefaults.standard.set(myTeamMovementsOriginal, forKey: "myTeamMovementsOriginal")
                    
                }
                
                tableView.reloadData()
                
            } else {
                noTeamLabel.isHidden = false
                selectedPkms.removeAll()
                tableView.reloadData()
            }
            
        } else {
            noTeamLabel.isHidden = false
            selectedPkms.removeAll()
            tableView.reloadData()
        }
    }
    
    func configOnce() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = .mainPink()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 35)!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationItem.title = "Mi Equipo"
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "x.circle"), style: .plain, target: self, action: #selector(deleteAllPokemons))]
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "icloud.and.arrow.down"), style: .plain, target: self, action: #selector(downloadYourTeam)),UIBarButtonItem(image: UIImage(systemName: "icloud.and.arrow.up"), style: .plain, target: self, action: #selector(uploadYourTeam))]
        
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        view.backgroundColor = .white
        
        noTeamLabel.layer.zPosition = 2
        
        tableView.frame = view.bounds
        tableView.layer.zPosition = 0
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
    }
    
    
    // Selectores
    @objc func downloadYourTeam() {
        print("Descarga tu equipo del servidor!")
        
        guard let user = Auth.auth().currentUser else {return}
            
        Database.database().reference().child("usuarios").child(user.uid).observeSingleEvent(of: .value) { snapshot in
            guard let team = snapshot.childSnapshot(forPath: "team").value as? [Int], let teamMovements = snapshot.childSnapshot(forPath: "teamMovements").value as? [[String]], let teamMovementsOriginal = snapshot.childSnapshot(forPath: "teamMovementsOriginal").value as? [[String]] else {
                
                self.noTeamLabel.isHidden = false
                self.selectedPkms.removeAll()
                UserDefaults.standard.set([], forKey: "myTeam")
                UserDefaults.standard.set([], forKey: "myTeamMovements")
                UserDefaults.standard.set([], forKey: "myTeamMovementsOriginal")
                self.tableView.reloadData()
                
                return
            }
            print(team,teamMovements,teamMovementsOriginal)
            
            guard team.count != 0 || teamMovements.count != 0 || teamMovementsOriginal.count != 0 else {
                CustomToast.show(message: "No se tienen datos guardados", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                return
            }
            
            UserDefaults.standard.set(team, forKey: "myTeam")
            UserDefaults.standard.set(teamMovements, forKey: "myTeamMovements")
            UserDefaults.standard.set(teamMovementsOriginal, forKey: "myTeamMovementsOriginal")
            self.checkForPokemons()
        }
        
    }
    
    @objc func uploadYourTeam() {
        print("Sube tu equipo al servidor!")
         
        guard let user = Auth.auth().currentUser else {return}
        
        if var myTeam = UserDefaults.standard.object(forKey: "myTeam") as? [Int], var myTeamMovements = UserDefaults.standard.object(forKey: "myTeamMovements") as? [[String]], var myTeamMovementsOriginal = UserDefaults.standard.object(forKey: "myTeamMovementsOriginal") as? [[String]]  {
            
            guard myTeam.count != 0 || myTeamMovementsOriginal.count != 0 else {
                CustomToast.show(message: "Tu equipo ha de tener al menos 1 Pokémon", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                return
            }
            
            var oneWithoutAttacks = false
            for pkmMovements in myTeamMovementsOriginal {
                if pkmMovements.filter({ $0 != "-" }).count == 0 {
                    oneWithoutAttacks = true
                }
            }
            
            guard oneWithoutAttacks != true else {
                CustomToast.show(message: "Los pokemons han de tener al menos un ataque", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                return
            }
            
            Database.database().reference().child("usuarios").child(user.uid).child("team").setValue(myTeam)
            Database.database().reference().child("usuarios").child(user.uid).child("teamMovements").setValue(myTeamMovements)
            Database.database().reference().child("usuarios").child(user.uid).child("teamMovementsOriginal").setValue(myTeamMovementsOriginal)
            
            CustomToast.show(message: "¡Tu equipo se ha guardado con éxito!", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
            
        }
        
    }
    
    @objc func deleteAllPokemons() {
        
        if var myTeam = UserDefaults.standard.object(forKey: "myTeam") as? [Int], var myTeamMovements = UserDefaults.standard.object(forKey: "myTeamMovements") as? [[String]], var myTeamMovementsOriginal = UserDefaults.standard.object(forKey: "myTeamMovementsOriginal") as? [[String]]  {
            
            guard myTeam.count == 0 || myTeamMovements.count == 0 else {
                
                // Create Alert
                var dialogMessage = UIAlertController(title: "¡Atención!", message: "Estas a punto de borrar todos los pokemon de tu equipo.", preferredStyle: .alert)
                // Create OK button with action handler
                let ok = UIAlertAction(title: "Aceptar", style: .default, handler: { (action) -> Void in
                    
                    let pokemons: [Int] = []
                    let movements: [[String]] = []
                    let movementsOriginal: [[String]] = []
                    
                    UserDefaults.standard.set(pokemons, forKey: "myTeam")
                    UserDefaults.standard.set(movements, forKey: "myTeamMovements")
                    UserDefaults.standard.set(movementsOriginal, forKey: "myTeamMovementsOriginal")
                    
                    self.checkForPokemons()
                    
                    CustomToast.show(message: "Equipo eliminado con éxito", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                    
                })
                // Create Cancel button with action handlder
                let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (action) -> Void in
                    
                }
                //Add OK and Cancel button to an Alert object
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)
                // Present alert message to user
                self.present(dialogMessage, animated: true, completion: nil)
                
                return
            }
            
            
        }
    }
    
    
    // TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPkms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTeamCell.identifier, for: indexPath) as! PokemonTeamCell
        cell.isUserInteractionEnabled = true
        
        cell.setData(pokemon: selectedPkms[indexPath.row], index: indexPath.row)
        cell.deletePokemon.tag = indexPath.row
        cell.deletePokemon.addTarget(self, action: #selector(deletePokemon(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deletePokemon(_ sender: UIButton) {
        
        // Se elimina el pokemon
        if var myTeam = UserDefaults.standard.object(forKey: "myTeam") as? [Int] {
            myTeam.remove(at: sender.tag)
            print(myTeam)
            UserDefaults.standard.set(myTeam, forKey: "myTeam")
        }
        
        // se elimina el array de movimientos del pokemon
        if var myTeamMovements = UserDefaults.standard.object(forKey: "myTeamMovements") as? [[String]] {
            myTeamMovements.remove(at: sender.tag)
            print(myTeamMovements)
            UserDefaults.standard.set(myTeamMovements, forKey: "myTeamMovements")
        }
        
        if var myTeamMovementsOriginal = UserDefaults.standard.object(forKey: "myTeamMovementsOriginal") as? [[String]] {
            myTeamMovementsOriginal.remove(at: sender.tag)
            print(myTeamMovementsOriginal)
            UserDefaults.standard.set(myTeamMovementsOriginal, forKey: "myTeamMovementsOriginal")
        }
        
        selectedPkms.remove(at: sender.tag)
        tableView.deleteRows(at:[ IndexPath(row: sender.tag, section: 0)],with: .left)
        checkForPokemons()
    }
    
    
}
