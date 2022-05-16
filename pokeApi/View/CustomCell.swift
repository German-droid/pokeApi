//
//  CustomCell.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 7/4/22.
//

import UIKit

class CustomCell: UITableViewCell {
    static let identifier = "CustomCell"
    
    func setData(name: String, index: Int, imageData: Data, firstType: String, secondType: String) {
        pokemonName.text = name.firstUppercased
        pokemonIndex.text = "#\(index+1)"
        pokemonImage.image = UIImage(data: imageData)
        
        pokemonImage.backgroundColor = pokemonImage.image?.cropToRect(rect: CGRect(x: 40, y: 40, width: 15, height: 15))?.averageColor
        //pokemonImage.layer.cornerRadius = 50
        
        
        
        
        firstTypeImage.image = UIImage(named: "Tipo_\(firstType)")
        
        if secondType == "" {
            secondTypeImage.image = UIImage()
        } else {
            secondTypeImage.image = UIImage(named: "Tipo_\(secondType)")
        }
    }
    
    let spacerView = UIView()
    
    // Nombre del pokemon
    public var pokemonName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Bulbasaur"
        label.font = UIFont(name: "Pokemon-Pixel-Font", size: 45)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        //label.backgroundColor = .orange
        
        return label
    }()
    
    // Indice del pokemon
    private var pokemonIndex: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "#001"
        label.textAlignment = .right
        label.font = UIFont(name: "Pokemon-Pixel-Font", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        //label.backgroundColor = .cyan
        
        return label
    }()
    
    // Tipo principal del pokemon
    private var firstTypeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Tipo_Planta")
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        
        return image
    }()
    
    // Tipo secundario opcional del pokemon
    private var secondTypeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Tipo_Veneno")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    // Foto del pokemon
    public var pokemonImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage()
        image.clipsToBounds = true
        image.contentMode = .center
        //image.backgroundColor = .red
        return image
    }()
    
    
    
    // Contenedor StackView principal donde va todo el contenido
    lazy private var mainContainerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dataContainerStack,pokemonImage])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 10
        //stack.backgroundColor = .blue
        
        return stack
    }()
    
    // Contenedor StackView para la información del pokemon
    lazy private var dataContainerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [indexNameContainerStack,typesContainerStack])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 5
        //stack.backgroundColor = .yellow
        
        return stack
    }()
    
    // Contenedor StackView para el nombre y el índice del pokemon
    lazy private var indexNameContainerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pokemonName,pokemonIndex])
        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .fillProportionally
        stack.spacing = 10
        //stack.backgroundColor = .green
        
        return stack
    }()
    
    // Contenedor StackView para los tipos del pokemon
    lazy private var typesContainerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstTypeImage,secondTypeImage,spacerView])
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 5
        
        return stack
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.addSubview(mainContainerStack)
        
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        // Desactivar constraints por defecto
        pokemonName.translatesAutoresizingMaskIntoConstraints = false
        pokemonIndex.translatesAutoresizingMaskIntoConstraints = false
        pokemonImage.translatesAutoresizingMaskIntoConstraints = false
        firstTypeImage.translatesAutoresizingMaskIntoConstraints = false
        secondTypeImage.translatesAutoresizingMaskIntoConstraints = false
        mainContainerStack.translatesAutoresizingMaskIntoConstraints = false
        dataContainerStack.translatesAutoresizingMaskIntoConstraints = false
        typesContainerStack.translatesAutoresizingMaskIntoConstraints = false
        indexNameContainerStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        // Activar las straints que queremos
        NSLayoutConstraint.activate([
            
            // Pokemon Name
            pokemonName.bottomAnchor.constraint(equalTo: indexNameContainerStack.bottomAnchor, constant: 0),
            pokemonName.topAnchor.constraint(equalTo: indexNameContainerStack.topAnchor, constant: 0),
            
            // Pokemon Index
            pokemonIndex.topAnchor.constraint(equalTo: indexNameContainerStack.topAnchor, constant: 0),
            pokemonIndex.widthAnchor.constraint(equalToConstant: 40),
            
            // Pokemon Image
            pokemonImage.widthAnchor.constraint(equalToConstant: 100),
            pokemonImage.heightAnchor.constraint(equalToConstant: 100),
            //pokemonImage.centerYAnchor.constraint(equalTo: mainContainerStack.centerYAnchor),
            pokemonImage.trailingAnchor.constraint(equalTo: mainContainerStack.trailingAnchor, constant: -10),
            
            // Types Images
            firstTypeImage.widthAnchor.constraint(equalToConstant: 75),
            firstTypeImage.heightAnchor.constraint(equalToConstant: 16),
            secondTypeImage.widthAnchor.constraint(equalToConstant: 75),
            secondTypeImage.heightAnchor.constraint(equalToConstant: 16),
            
            // Index and Name Stack View
            //indexNameContainerStack.leadingAnchor.constraint(equalTo: mainContainerStack.leadingAnchor, constant: 5),
            indexNameContainerStack.heightAnchor.constraint(equalToConstant: mainContainerStack.frame.size.height/2),
            
            // Types Stack View
            //typesContainerStack.leadingAnchor.constraint(equalTo: mainContainerStack.leadingAnchor, constant: 5),
            typesContainerStack.heightAnchor.constraint(equalToConstant: mainContainerStack.frame.size.height/2),
            
            // Data Stack View
            dataContainerStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            // Main Stack View
            mainContainerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainContainerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainContainerStack.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            mainContainerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
            
            
        ])
        
    }
    
    
    
    
}
