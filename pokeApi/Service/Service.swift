//
//  Service.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 3/5/22.
//

import Combine
import Foundation
import CoreData
import UIKit
import OrderedCollections

class Service {
    
    static let shared = Service()
    let BASE_URL = "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0"
    let SPECIES_URL = "https://pokeapi.co/api/v2/pokemon-species/"
    let MOVE_URL = "https://pokeapi.co/api/v2/move/"
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchAllFromApiToCoredata() {
        guard let url = URL(string: BASE_URL) else {return}
        
        //var dicPkm = OrderedDictionary<Int, ResumePokemon>()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Fallo al obtener los datos con el error: ", error.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(AllPokemons.self, from: data)
                
                for (_,pokemon) in result.results.enumerated() {
                    //dicPkm[index] = pokemon
                    self.fetchDetailedPokemon(url: pokemon.url) { detailedPokemon in
                        //print(detailedPokemon.sprites.other.officialSprite.url)
                        self.fetchImagePokemon(imageUrl: detailedPokemon.sprites.url) { imageData in
                            
                            self.fetchBackImagePokemon(imageUrl: detailedPokemon.sprites.backUrl) { backImageData in
                                self.fetchArtWorkPokemon(artWorkUrl: detailedPokemon.sprites.other.officialSprite.url) { artworkData in
                                    self.addToPersistent(pokemon: detailedPokemon, imageData: imageData, backImageData: backImageData, artworkData: artworkData)
                                }
                            }
                            
                        }
                    }
                    
                }
                
            } catch let error {
                print("Error al crear el JSON con el error: ", error.localizedDescription)
            }
            
        }.resume()
    }
    
    func fetchDetailedPokemon(url: String, completion: @escaping (DetailedPokemon) -> ()) {
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fallo al obtener los datos detallados con el error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let detailedPokemon = try JSONDecoder().decode(DetailedPokemon.self, from: data)
                completion(detailedPokemon)
            } catch let error {
                print("Error al crear el JSON con el error: ", error.localizedDescription)
                return
            }
        }.resume()
    }
    
    func fetchImagePokemon(imageUrl: String, completion: @escaping (Data) -> ()) {
        guard let url = URL(string: imageUrl) else {return}

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fallo al obtener la imagen del pokemon con el error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
    
    func fetchBackImagePokemon(imageUrl: String, completion: @escaping (Data) -> ()) {
        guard let url = URL(string: imageUrl) else {return}

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fallo al obtener la imagen del pokemon con el error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
    
    func fetchArtWorkPokemon(artWorkUrl: String, completion: @escaping (Data) -> ()) {
        guard let artworkUrl = URL(string: artWorkUrl) else {return}
        
        URLSession.shared.dataTask(with: artworkUrl) { data, response, error in
            if let error = error {
                print("Fallo al obtener la imagen del pokemon con el error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
    
    func fetchSpecies(id: Int, completion: @escaping (SpeciesPokemon) -> () ) {
        guard let artworkUrl = URL(string: "\(SPECIES_URL)\(id)") else {return}
        
        URLSession.shared.dataTask(with: artworkUrl) { data, response, error in
            if let error = error {
                print("Fallo al obtener la imagen del pokemon con el error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let speciesPokemon = try JSONDecoder().decode(SpeciesPokemon.self, from: data)
                DispatchQueue.main.async {
                    completion(speciesPokemon)
                }
            } catch let error {
                print("Error al crear el JSON con el error: ", error.localizedDescription)
                return
            }
        }.resume()
    }
    
    func fetchOneMove(url: String, completion: @escaping (DetailedMovement) -> () ) {
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fallo al obtener los datos detallados con el error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                var detailedMovement = try JSONDecoder().decode(DetailedMovement.self, from: data)
                completion(detailedMovement)
            } catch let error {
                print("Error al crear el JSON con el error: ", error.localizedDescription)
                return
            }
        }.resume()
        
        
    }
    
    func addToPersistent(pokemon: DetailedPokemon, imageData: Data, backImageData: Data , artworkData: Data) {
        
        // Pokemon entity
        let newPokemon = DetailedPokemons(context: managedContext)
        newPokemon.setValue(pokemon.name, forKey: "name")
        newPokemon.setValue(pokemon.height, forKey: "height")
        newPokemon.setValue(pokemon.weight, forKey: "weight")
        newPokemon.setValue(imageData, forKey: "sprite")
        newPokemon.setValue(backImageData, forKey: "backSprite")
        newPokemon.setValue(artworkData, forKey: "detailedSprite")
        newPokemon.setValue(pokemon.id, forKey: "id")
        
        // Stats entity
        let newStats = Base_Stats(context: managedContext)
        
        for pkmStat in pokemon.stats {
            switch pkmStat.name.name {
            case "special-attack":
                newStats.setValue(pkmStat.value, forKey: "specialAttack")
            case "special-defense":
                newStats.setValue(pkmStat.value, forKey: "specialDefense")
            default:
                newStats.setValue(pkmStat.value, forKey: pkmStat.name.name)
            }
        }
        
        newPokemon.stats = newStats

        // Types entity
        for pkmType in pokemon.types {
            let newType = Types(context: managedContext)
            newType.setValue(pkmType.type.name, forKey: "name")
            newType.setValue(pkmType.slot, forKey: "slot")
            
            newPokemon.addToTypes(newType)
        }
        
        //print("-----",pokemon.name, "-----")
        
        // Movements entity
        for pkmMove in pokemon.moves {
            let newMove = DetailedMovements(context: managedContext)
            newMove.setValue(String(pkmMove.move.name), forKey: "name")
            //print(pkmMove.move.name)
            newPokemon.addToMovements(newMove)
        }
        
        
        do {
            try self.managedContext.save()
            //print("Saved \(pokemon.name).")
        } catch let error as NSError {
            print("Could not save \(pokemon.name). \(error)")
        }
        
    }

    func fetchAllPokemonFromCoreData(completion: @escaping (OrderedDictionary<Int,DetailedPokemons>) -> ()) {
        
        var dictionaryPKM = OrderedDictionary<Int,DetailedPokemons>()
        
        do {
            let allSaved = try managedContext.fetch(DetailedPokemons.fetchRequest())
            
            let sorteAllSaved = allSaved.sorted {
                $0.id < $1.id
            }
            
            for (index,pokemon) in sorteAllSaved.enumerated() {
                //print(pokemon)
                dictionaryPKM[index] = pokemon
            }
            
            completion(dictionaryPKM)
        } catch let error {
            print("No se pudieron obtener los datos de Core Data. \(error.localizedDescription)")
        }
    }
    
    func fetchOneFromCoreData(id: Int, completion: @escaping (DetailedPokemons) -> ()) {
        
        let fetchRequest: NSFetchRequest<DetailedPokemons>
        fetchRequest = DetailedPokemons.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "id LIKE %@", String(id)
        )
        
        
        do {
            let pokemon = try managedContext.fetch(fetchRequest)
            
            completion(pokemon[0])
        } catch let error {
            print("No se pudieron obtener los datos de Core Data. \(error.localizedDescription)")
        }
    }
    
    func deleteFromPersistent() {
        do {
            let allSaved = try managedContext.fetch(DetailedPokemons.fetchRequest())
            
            //print(allSaved.count)
            for pokemon in allSaved {
                self.managedContext.delete(pokemon)
            }
            try managedContext.save()
        } catch let error {
            print("No se puedieron borrar los datos de CoreData. \(error.localizedDescription)")
        }
    }

}

enum Errores: Error {
    case urlError
    case getDataError
    case parseError
}

class ApiCaller {
    let hisdh = "271a-FPhLPw93o3Fj8j2tgOREay8an2E"
    let BASE_URL = "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0"
    static let shared = ApiCaller()
    
    func fetchDetailedPokemon(resumePokemon: ResumePokemon) -> AnyPublisher<DetailedPokemon, Error> {
        let url = URL(string: resumePokemon.url)!
        
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) in
                return data
            }
            .decode(type: DetailedPokemon.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        return publisher
    }
    
}

class PokemonGetter: ObservableObject {
    @Published var pokemon: [DetailedPokemon] = [] {
        didSet {
            print("Pokémon list updated!")
            for pokemon in pokemon {
                print("Pokémon \(pokemon.id): \(pokemon.name)")

            }
        }
    }

    private let BASE_URL = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0")!
    let jsonDecoder = JSONDecoder()

    private var subscription: AnyCancellable?

    func start() {
        print("Starting...")
        if subscription != nil {
            subscription?.cancel()
        }

        subscription = URLSession.shared.dataTaskPublisher(for: BASE_URL)
            .map(\.data)
            .decode(type: AllPokemons.self, decoder: jsonDecoder)
            .flatMap { response in
                Publishers.MergeMany(
                    response.results.map(self.namedResourceGetter)
                )
                .collect()
            }
            .replaceError(with: [])
            .sink { pokemon in
                self.pokemon = pokemon.sorted(by: { $0.id < $1.id })
            }
    }

    private func namedResourceGetter(_ resumePokemon: ResumePokemon) -> AnyPublisher<DetailedPokemon, Error> {
        URLSession.shared.dataTaskPublisher(for: URL(string: resumePokemon.url)!)
            .map { $0.data }
            .decode(type: DetailedPokemon.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    private func imageGetter(_ detailedPokemon: DetailedPokemon) -> AnyPublisher<Data, URLError> {
        URLSession.shared.dataTaskPublisher(for: URL(string: detailedPokemon.sprites.url)!)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    private func artworkGetter(_ detailedPokemon: DetailedPokemon) -> AnyPublisher<Data, URLError> {
        URLSession.shared.dataTaskPublisher(for: URL(string: detailedPokemon.sprites.other.officialSprite.url)!)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

//DetailedPokemon(id: 999, name: "Error", types: [], sprites: PokemonSprite(url: "Error", other: QualitySprite(officialSprite: QualityImage(url: "Error"))), height: 0, weight: 0, stats: [], moves: [])

