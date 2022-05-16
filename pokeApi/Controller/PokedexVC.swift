//
//  MainVC.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 4/4/22.
//

import Combine
import Foundation
import UIKit
//import FirebaseAuth
//import FirebaseDatabase
import OrderedCollections
import CoreData

class PokedexVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private var pokemonSubscriber: AnyCancellable?
    private var detailedPokemonSubscriber: AnyCancellable?
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //var resumenDic = OrderedDictionary<Int, ResumePokemon>()
    //var detailedDic = OrderedDictionary<Int, DetailedPokemon>()
    var storedDic = OrderedDictionary<Int, DetailedPokemons>() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 110
        table.allowsSelection = true
        table.isUserInteractionEnabled = true
        table.separatorColor = .mainPink()
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.register(MyCustomCell.nib(), forCellReuseIdentifier: MyCustomCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if checkIfItemExist() {
            
            Service.shared.fetchAllPokemonFromCoreData { pkmDic in
                self.storedDic = pkmDic
            }
            
        } else {
            
            Service.shared.fetchAllFromApiToCoredata()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                Service.shared.fetchAllPokemonFromCoreData { pkmDic in
                    self.storedDic = pkmDic
                }
            }
            
        }

        //print(checkIfItemExist())
        
    }
    
    func checkIfItemExist() -> Bool {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DetailedPokemons")

        do {
            let count = try managedContext.count(for: fetchRequest)
            if count > 0 {
                return true
            }else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false

        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = .mainPink()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Pokemon-Pixel-Font", size: 35)!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationItem.title = "Pokedex"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        view.backgroundColor = .black
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    // Selectores
    @objc func showSearchBar() {
        print("esto es el buscador")
    }
    
    // TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storedDic.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        if let detailedPkm = self.storedDic[indexPath.row] {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let pokemonViewController = storyBoard.instantiateViewController(withIdentifier: "pokemonVC") as! PokemonVC
            pokemonViewController.detailedPkm = detailedPkm
            navigationController?.pushViewController(pokemonViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCustomCell.identifier, for: indexPath) as! MyCustomCell
        cell.isUserInteractionEnabled = true
        
        //cell.pokemonName.text = resumenDic[indexPath.row]?.name
        
        //cell.pokemonName.text = storedDic[indexPath.row]?.name ?? ""
        if let name = storedDic[indexPath.row]?.name, let imageData = storedDic[indexPath.row]?.sprite {
            
            var typeOne = "", typeTwo = ""
            
            for pkmtype in storedDic[indexPath.row]?.types! as! Set<Types> {
                if (pkmtype.slot == 1) {
                    typeOne = pkmtype.name ?? ""
                } else {
                    typeTwo = pkmtype.name ?? ""
                }
            }
            
            cell.setData(name: name, index: indexPath.row, imageData: imageData, firstType: typeOne, secondType: typeTwo)
        } else {
            return UITableViewCell()
        }
        
        return cell
    }
    
}
