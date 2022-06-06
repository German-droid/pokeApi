//
//  DetailedPkmViewController.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 6/5/22.
//

import Foundation
import UIKit
import SwiftUI
import OrderedCollections

class PokemonVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var pkmName: UILabel!
    @IBOutlet weak var pkmImage: UIImageView!
    @IBOutlet weak var pkmTypeOne: UIImageView!
    @IBOutlet weak var pkmTypeTwo: UIImageView!
    @IBOutlet weak var pkmDescription: UILabel!
    @IBOutlet weak var pkmSpecie: UILabel!
    @IBOutlet weak var pkmRatio: UILabel!
    @IBOutlet weak var pkmWeight: UILabel!
    @IBOutlet weak var pkmHeight: UILabel!
    @IBOutlet weak var pkmHp: UILabel!
    @IBOutlet weak var pkmHpBar: UIProgressView!
    @IBOutlet weak var pkmAtaque: UILabel!
    @IBOutlet weak var pkmAtaqueBar: UIProgressView!
    @IBOutlet weak var pkmDefensa: UILabel!
    @IBOutlet weak var pkmDefensaBar: UIProgressView!
    @IBOutlet weak var pkmAtaqueEsp: UILabel!
    @IBOutlet weak var pkmAtaqueEspBar: UIProgressView!
    @IBOutlet weak var pkmDefensaEsp: UILabel!
    @IBOutlet weak var pkmDefensaEspBar: UIProgressView!
    @IBOutlet weak var pkmVelocidad: UILabel!
    @IBOutlet weak var pkmVelocidadBar: UIProgressView!
    @IBOutlet weak var pkmTotal: UILabel!
    @IBOutlet weak var pkmTotalBar: UIProgressView!
    @IBOutlet weak var movesTableView: UITableView!
    @IBOutlet weak var movesTableViewHeight: NSLayoutConstraint!

    
    var detailedPkm: DetailedPokemons!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movesTableView.register(MovementsTableViewCell.nib(), forCellReuseIdentifier: MovementsTableViewCell.identifier)
        self.movesTableView.delegate = self
        self.movesTableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToTeam))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        var arrMovements = detailedPkm.movements!.allObjects
        
        if detailedPkm.species == nil {
            Service.shared.fetchSpecies(id: Int(detailedPkm.id)) { [self] speciesPokemon in
                //print(speciesPokemon.flavor_text_entries[50].flavor_text)
                
                var esDescription = ""
                
                for texto in speciesPokemon.flavor_text_entries {
                    if texto.language.name == "es" && texto.version.name == "omega-ruby" {
                        esDescription = texto.flavor_text
                    }
                }

                // Stats entity
                let newSpecie = SpeciesPokemons(context: managedContext)
                newSpecie.entry = esDescription
                newSpecie.captureRatio = Int64(speciesPokemon.capture_rate)
                newSpecie.specie = speciesPokemon.genera[5].genus
                
                self.detailedPkm.species = newSpecie
                //print(speciesPokemon.flavor_text_entries[50].flavor_text,"AAAA")
                
                DispatchQueue.main.async {
                    self.pkmRatio.text = String(speciesPokemon.capture_rate)
                    self.pkmSpecie.text = String(speciesPokemon.genera[5].genus)
                    self.pkmDescription.text = String(esDescription)
                }
                
                do {
                    try self.managedContext.save()
                } catch let error as NSError {
                    print("Could not update \(self.detailedPkm.name ?? "pokemon"). \(error)")
                }
            }
        }
        
        for (index,movement) in arrMovements.enumerated()  {
            if let detailedMovement = movement as? DetailedMovements {
                
                if detailedMovement.pp == 0 {
                    //print("dento",detailedMovement.name!)
                    Service.shared.fetchOneMove(url: "https://pokeapi.co/api/v2/move/\(detailedMovement.name!)") { [self] detailedMovement in
                        //print(detailedMovement)
                    
                        // Nombre en español
                        var esNombreAtq = ""
                        
                        for nombresAtq in detailedMovement.names {
                            if nombresAtq.language.name == "es" {
                                esNombreAtq = nombresAtq.name
                            }
                        }
                        
                        //print(detailedPkm.movements?)
                        
                        // DetailedMovements entity
                        let newMovement = DetailedMovements(context: managedContext)
                        newMovement.originalName = detailedMovement.name
                        newMovement.name = esNombreAtq
                        newMovement.power = Int64(detailedMovement.power ?? 0)
                        newMovement.accuracy = Int64(detailedMovement.accuracy ?? 0)
                        newMovement.pp = Int64(detailedMovement.pp)
                        newMovement.type = detailedMovement.type.name
                        newMovement.damageClass = detailedMovement.damage_class.name
                        
                        
                        arrMovements[index] = newMovement
                        
                        self.detailedPkm.movements = NSSet(array: arrMovements)
                        
                        DispatchQueue.main.async {
                            movesTableViewHeight.constant = CGFloat((arrMovements.count * 100))
                            self.movesTableView.reloadData()
                        }
                        
                        
                        do {
                            try self.managedContext.save()
                        } catch let error as NSError {
                            print("Could not update \(self.detailedPkm.name ?? "pokemon"). \(error)")
                        }
                        
                    }
                }

            }
        }

        
        let gradientView = LinearGradient(frame: pkmTotalBar.bounds)
        setBarsProperties(gradientView: gradientView)
        setPokemonInfo()
        setTableHeight(count: detailedPkm.movements!.count)
    }
    
    func setTableHeight(count: Int) {
        movesTableViewHeight.constant = CGFloat((count * 100))
    }
    
    func setBarsProperties(gradientView: LinearGradient) {
        
        // Bars progress used as not filled
        pkmHpBar.progressTintColor = .white
        pkmAtaqueBar.progressTintColor = .white
        pkmDefensaBar.progressTintColor = .white
        pkmAtaqueEspBar.progressTintColor = .white
        pkmDefensaEspBar.progressTintColor = .white
        pkmVelocidadBar.progressTintColor = .white
        pkmTotalBar.progressTintColor = .white

        // Bars background used as filled
        pkmHpBar.trackImage = UIImage(view: gradientView).withHorizontallyFlippedOrientation()
        pkmAtaqueBar.trackImage = UIImage(view: gradientView).withHorizontallyFlippedOrientation()
        pkmDefensaBar.trackImage = UIImage(view: gradientView).withHorizontallyFlippedOrientation()
        pkmAtaqueEspBar.trackImage = UIImage(view: gradientView).withHorizontallyFlippedOrientation()
        pkmDefensaEspBar.trackImage = UIImage(view: gradientView).withHorizontallyFlippedOrientation()
        pkmVelocidadBar.trackImage = UIImage(view: gradientView).withHorizontallyFlippedOrientation()
        pkmTotalBar.trackImage = UIImage(view: gradientView).withHorizontallyFlippedOrientation()
        
        // Flip Horizontally the bar
        pkmHpBar.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        pkmAtaqueBar.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        pkmDefensaBar.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        pkmAtaqueEspBar.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        pkmDefensaEspBar.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        pkmVelocidadBar.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        pkmTotalBar.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        
        // Bars progress
        guard let pkmHp = detailedPkm.stats?.hp, let pkmAtk = detailedPkm.stats?.attack, let pkmDef = detailedPkm.stats?.defense, let pkmAtkSp = detailedPkm.stats?.specialAttack, let pkmDefSp = detailedPkm.stats?.specialDefense, let pkmSpeed = detailedPkm.stats?.speed else {return}
        
        let total = pkmHp + pkmAtk + pkmDef + pkmAtkSp + pkmDefSp + pkmSpeed
        
        // Values of the max of the pokemon (255) to get the max of the progress bar (1)
        
        pkmHpBar.setProgress(Float(1 - Float(pkmHp) / Float(255)), animated: true)
        pkmAtaqueBar.setProgress(Float(1 - Float(pkmAtk) / Float(255)), animated: true)
        pkmDefensaBar.setProgress(Float(1 - Float(pkmDef) / Float(255)), animated: true)
        pkmAtaqueEspBar.setProgress(Float(1 - Float(pkmAtkSp) / Float(255)), animated: true)
        pkmDefensaEspBar.setProgress(Float(1 - Float(pkmDefSp) / Float(255)), animated: true)
        pkmVelocidadBar.setProgress(Float(1 - Float(pkmSpeed) / Float(255)), animated: true)
        pkmTotalBar.setProgress(Float(1 - Float(total) / Float(780)), animated: true)
        
    }
    
    func setPokemonInfo() {
        //print(detailedPkm)
        
        // Title
        self.title = "\(self.detailedPkm.id)"
        
        // Pokemon Name
        self.pkmName.text = detailedPkm.name?.firstCapitalized
        
        // Pokemon Index
        if self.detailedPkm.id < 10 {
            title = "#00\(self.detailedPkm.id)"
            //print(self.detailedPkm.id)
        } else if self.detailedPkm.id >= 10 && self.detailedPkm.id < 100 {
            title = "#0\(self.detailedPkm.id)"
        } else {
            title = "#\(self.detailedPkm.id)"
        }
        
        // Pokemon Stats
        guard let pkmHp = detailedPkm.stats?.hp, let pkmAtk = detailedPkm.stats?.attack, let pkmDef = detailedPkm.stats?.defense, let pkmAtkSp = detailedPkm.stats?.specialAttack, let pkmDefSp = detailedPkm.stats?.specialDefense, let pkmSpeed = detailedPkm.stats?.speed else {return}
        
        let total = pkmHp + pkmAtk + pkmDef + pkmAtkSp + pkmDefSp + pkmSpeed
        
        self.pkmHp.text = "\(pkmHp)"
        pkmAtaque.text = "\(pkmAtk)"
        pkmDefensa.text = "\(pkmDef)"
        pkmAtaqueEsp.text = "\(pkmAtkSp)"
        pkmDefensaEsp.text = "\(pkmDefSp)"
        pkmVelocidad.text = "\(pkmSpeed)"
        pkmTotal.text = "\(total)"
        
        // Pokemon Types
        for pkmtype in detailedPkm.types! as! Set<Types> {
            if (pkmtype.slot == 1) {
                pkmTypeOne.image = UIImage(named: "Tipo_\(pkmtype.name!)")
            } else {
                pkmTypeTwo.image = UIImage(named: "Tipo_\(pkmtype.name!)")
            }
        }
        
        if detailedPkm.types?.count == 1 {
            pkmTypeTwo.isHidden = true
        }
        
        
        // Pokemon Image
        pkmImage.image = UIImage(data: detailedPkm.detailedSprite!)
        pkmImage.backgroundColor = pkmImage.image?.cropToRect(rect: CGRect(x: 200, y: 200, width: 50, height: 50))?.averageColor
        pkmName.backgroundColor = pkmImage.image?.cropToRect(rect: CGRect(x: 200, y: 200, width: 50, height: 50))?.averageColor
        //pkmImage.layer.cornerRadius = 150
        
        // Specify which corners to round
        let corners = UIRectCorner(arrayLiteral: [
            UIRectCorner.bottomRight,
            UIRectCorner.bottomLeft
        ])

        // Determine the size of the rounded corners
        let cornerRadii = CGSize(
            width: 100,
            height: 100
        )

        // A mask path is a path used to determine what
        // parts of a view are drawn. UIBezier path can
        // be used to create a path where only specific
        // corners are rounded
        let maskPath = UIBezierPath(
            roundedRect: pkmImage.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )

        // Apply the mask layer to the view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = pkmImage.bounds

        pkmImage.layer.mask = maskLayer
        
        
        
        
        
        // Pokemon Specs
        pkmWeight.text = "\(detailedPkm.weight/10) kg"
        pkmHeight.text = "\(detailedPkm.height/10) m"
        pkmSpecie.text = "\(detailedPkm.species?.specie ?? "")"
        pkmRatio.text = "\( String(detailedPkm.species?.captureRatio ?? 0))"
        
        // Pokemon Desc
        pkmDescription.text = "\(detailedPkm.species?.entry ?? "")"
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        detailedPkm.movements!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovementsTableViewCell.identifier, for: indexPath) as! MovementsTableViewCell
        
        //print(detailedPkm.movements!.count)
        
        let arrMovements = detailedPkm.movements!.allObjects as! [DetailedMovements]
        let sortedMovements = arrMovements.sorted {
            $0.name! < $1.name!
        }
        let movement = sortedMovements[indexPath.row]
        
        cell.setData(movement: movement.name ?? "", power: Int(movement.power), acc: Int(movement.accuracy), pp: Int(movement.pp), type: movement.type ?? "", status: movement.damageClass ?? "")

        return cell
    }
    
    
    // Selectores
    @objc func addToTeam() {
        
        if var myTeam = UserDefaults.standard.object(forKey: "myTeam") as? [Int] {
            
            if myTeam.count < 6 {
                myTeam.append(Int(detailedPkm.id))
                UserDefaults.standard.set(myTeam, forKey: "myTeam")
                CustomToast.show(message: "\(detailedPkm.name!.firstUppercased) se añadió a tu equipo", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
            } else {
                CustomToast.show(message: "Ya tienes 6 pokemons en tu equipo", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
            }
            
            print(myTeam)
            
        } else {
            UserDefaults.standard.set([Int(detailedPkm.id)], forKey: "myTeam")
            CustomToast.show(message: "\(detailedPkm.name!.firstUppercased) se añadió a tu equipo", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
        }
        
    }
}
