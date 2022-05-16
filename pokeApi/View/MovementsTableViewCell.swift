//
//  MovementsCellTableViewCell.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 11/5/22.
//

import UIKit

class MovementsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moveName: UILabel!
    @IBOutlet weak var movePower: UILabel!
    @IBOutlet weak var moveAcc: UILabel!
    @IBOutlet weak var movePP: UILabel!
    @IBOutlet weak var moveStatus: UILabel!
    @IBOutlet weak var moveType: UIImageView!
    
    static let identifier = "MovementsTableViewCell"

    func setData(movement: String, power: Int, acc: Int, pp: Int, type: String, status: String) {
        
        self.moveName.text = movement.firstCapitalized
        
        if power == 0 {
            self.movePower.text = "-"
        } else {
            self.movePower.text = String(power)
        }
        
        if acc == 0 {
            self.moveAcc.text = "-"
        } else {
            self.moveAcc.text = String(acc)
        }
        
        if pp == 0 {
            self.movePP.text = "-"
        } else {
            self.movePP.text = String(pp)
        }
        
        self.moveType.image = UIImage(named: "Tipo_\(type)")
        
        switch status {
        case "status" :
            self.moveStatus.backgroundColor = .systemGray
        case "special":
            self.moveStatus.backgroundColor = .systemBlue
        case "physical":
            self.moveStatus.backgroundColor = .systemRed
        default:
            self.moveStatus.backgroundColor = .white
        }
        self.moveStatus.text = status.uppercased()
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MovementsTableViewCell", bundle: nil)
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
