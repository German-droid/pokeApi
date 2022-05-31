//
//  MyCustomCell.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 16/5/22.
//

import UIKit

class MyCustomCell: UITableViewCell {

    @IBOutlet weak var typesStackView: UIStackView!
    
    @IBOutlet weak var pokemonIndex: UILabel!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var firstTypeImage: UIImageView!
    @IBOutlet weak var secondTypeImage: UIImageView!
    @IBOutlet weak var pokemonImage: UIImageView!
    
    func setData(name: String, index: Int, imageData: Data, firstType: String, secondType: String) {
        
        self.pokemonName.text = name.firstUppercased
        
        if String(index).count == 1 {
            pokemonIndex.text = "#00\(index+1)"
        } else if String(index).count == 2 {
            pokemonIndex.text = "#0\(index+1)"
        } else {
            pokemonIndex.text = "#\(index+1)"
        }
        
        pokemonImage.image = UIImage(data: imageData)
        setImageBR()
        setTypesBR()
        pokemonImage.backgroundColor = pokemonImage.image?.cropToRect(rect: CGRect(x: 40, y: 40, width: 15, height: 15))?.averageColor
        typesStackView.backgroundColor = .rgb(red: 25, blue: 30, green: 32, alpha: 0.9)
        //pokemonImage.layer.cornerRadius = 50
        
        firstTypeImage.image = UIImage(named: "\(firstType)")
        
        if secondType == "" {
            secondTypeImage.image = UIImage()
        } else {
            secondTypeImage.image = UIImage(named: "\(secondType)")
        }
    }

    func setImageBR() {
        // Specify which corners to round
        let corners = UIRectCorner(arrayLiteral: [
            UIRectCorner.topLeft,
            UIRectCorner.bottomLeft
        ])

        // Determine the size of the rounded corners
        let cornerRadii = CGSize(
            width: 50,
            height: 50
        )

        // A mask path is a path used to determine what
        // parts of a view are drawn. UIBezier path can
        // be used to create a path where only specific
        // corners are rounded
        let maskPath = UIBezierPath(
            roundedRect: pokemonImage.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )

        // Apply the mask layer to the view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = pokemonImage.bounds

        pokemonImage.layer.mask = maskLayer
    }
    
    func setTypesBR() {
        // Specify which corners to round
        let corners = UIRectCorner(arrayLiteral: [
            UIRectCorner.topRight,
            UIRectCorner.bottomRight
        ])

        // Determine the size of the rounded corners
        let cornerRadii = CGSize(
            width: 30,
            height: 30
        )

        // A mask path is a path used to determine what
        // parts of a view are drawn. UIBezier path can
        // be used to create a path where only specific
        // corners are rounded
        let maskPath = UIBezierPath(
            roundedRect: typesStackView.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )

        // Apply the mask layer to the view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = typesStackView.bounds

        typesStackView.layer.mask = maskLayer
    }
    
    static let identifier = "MyCustomCell"

    static func nib() -> UINib {
        return UINib(nibName: "MyCustomCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
