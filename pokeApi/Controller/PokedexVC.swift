//
//  MainVC.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 4/4/22.
//

import Foundation
import UIKit
import FirebaseAuth
import OrderedCollections
import CoreData

class PokedexVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    let typesOrigin = ["All","Grass","Fire","Water","Normal","Electric","Psychic","Fighting","Rock","Ground","Flying","Bug","Poison","Dark","Ghost","Ice","Steel","Dragon","Fairy"]
    let scopeButtons = ["Todos","Planta","Fuego","Agua","Normal","Eléctrico","Psíquico","Lucha","Roca","Tierra","Volador","Bicho","Veneno","Siniestro","Fantasma","Hielo","Acero","Dragón","Hada"]
    let searchController = UISearchController()
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var filteredDic = [DetailedPokemons]()
    var storedDic = OrderedDictionary<Int, DetailedPokemons>() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage.gifImageWithName("pikachu-running")
        imageView.alpha = CGFloat(0.5)
        return imageView
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 110
        table.allowsSelection = true
        table.isUserInteractionEnabled = true
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.register(MyCustomCell.nib(), forCellReuseIdentifier: MyCustomCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        initSearchController()
        
        if checkIfItemExist() {
            
            imageView.isHidden = true
            imageView.animationImages = nil
            
            Service.shared.fetchAllPokemonFromCoreData { pkmDic in
                self.storedDic = pkmDic
            }
            
        } else {
            
            Service.shared.fetchAllFromApiToCoredata()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                
                Service.shared.fetchAllPokemonFromCoreData { pkmDic in
                    self.storedDic = pkmDic
                }
                
                self.imageView.isHidden = true
                self.imageView.animationImages = nil
            }
            
        }

        //print(checkIfItemExist())
        
    }
    
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        
        //navigationItem.searchController = searchController
        //navigationItem.searchController?.searchBar.isHidden = true
        
        
        navigationItem.searchController?.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
        navigationItem.hidesSearchBarWhenScrolling = false
        //searchController.searchBar.scopeButtonTitles = scopeButtons
        searchController.searchBar.delegate = self
        
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

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationItem.searchController?.searchBar.searchTextField.backgroundColor = .white
        navigationItem.searchController?.searchBar.backgroundColor = .mainPink()
        navigationItem.searchController?.searchBar.barTintColor = .white
        navigationItem.searchController?.searchBar.tintColor = .white
        navigationItem.searchController?.searchBar.searchTextField.tokenBackgroundColor = .white
        navigationItem.searchController?.searchBar.searchTextField.tintColor = .black
        navigationItem.searchController?.searchBar.searchTextField.textColor = .black
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
    
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = .mainPink()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Pokemon-Pixel-Font", size: 35)!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationItem.title = "Pokedex"
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logOut)),UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))]
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        view.backgroundColor = .white
        
        imageView.layer.zPosition = 2
        imageView.frame = CGRect(x: (view.bounds.size.width / 2) - 110, y: (view.bounds.size.height / 2) - 160, width: 220, height: 160)
        
        tableView.frame = view.bounds
        tableView.layer.zPosition = 0
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        view.addSubview(tableView)
        view.addSubview(imageView)
    }
    
    // Selectores
    @objc func showSearchBar() {
        
        if navigationItem.searchController == nil {
            print("es nil")
            navigationItem.searchController = searchController
        } else {
            print("no es nil")
            navigationItem.searchController = nil
        }
        
    }
    
    @objc func logOut() {
        print("log out")
        do {
            try Auth.auth().signOut()
            navigationController?.navigationController?.popViewController(animated: true)
        } catch {
            print("Error, no user logged")
        }
    }
    
    // TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredDic.count : storedDic.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
            
        if let detailedPkm = searchController.isActive ? filteredDic[indexPath.row] : storedDic[indexPath.row] {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let pokemonViewController = storyBoard.instantiateViewController(withIdentifier: "pokemonVC") as! PokemonVC
            pokemonViewController.detailedPkm = detailedPkm
            navigationController?.pushViewController(pokemonViewController, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCustomCell.identifier, for: indexPath) as! MyCustomCell
        cell.isUserInteractionEnabled = true
        
        //print(indexPath.row)
        
        //let name = storedDic[indexPath.row]?.name, let imageData = storedDic[indexPath.row]?.sprite
        //print(searchController.isActive ? filteredDic[indexPath.row].name : storedDic[indexPath.row]?.name)
        //print(searchController.isActive ? filteredDic[indexPath.row].sprite : storedDic[indexPath.row]?.sprite)
        
        if let name = searchController.isActive ? filteredDic[indexPath.row].name : storedDic[indexPath.row]?.name, let imageData = searchController.isActive ? filteredDic[indexPath.row].sprite : storedDic[indexPath.row]?.sprite {
            
            var typeOne = "", typeTwo = ""
            
            for pkmtype in searchController.isActive ? filteredDic[indexPath.row].types! as! Set<Types> : storedDic[indexPath.row]?.types! as! Set<Types> {
                if (pkmtype.slot == 1) {
                    typeOne = pkmtype.name ?? ""
                } else {
                    typeTwo = pkmtype.name ?? ""
                }
            }
            
            cell.setData(name: name, index: searchController.isActive ? Int(filteredDic[indexPath.row].id)-1 : indexPath.row, imageData: imageData, firstType: typeOne, secondType: typeTwo)
        } else {
            print("algo salio mal")
            return UITableViewCell()
        }
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
    
        filterForSearchTextAndScopeButton(searchText: searchText)
    
    }
    
    func filterForSearchTextAndScopeButton(searchText: String) {
        filteredDic.removeAll()

        var searchTextMatch: Bool
        for (index,pokemon) in storedDic {
            
            if searchController.searchBar.text != "" {
                searchTextMatch = pokemon.name!.lowercased().contains(searchText.lowercased())
            } else {
                searchTextMatch = true
            }
            
            if searchTextMatch {
                filteredDic.append(pokemon)
            }

        }
        tableView.reloadData()
    }
    
}
