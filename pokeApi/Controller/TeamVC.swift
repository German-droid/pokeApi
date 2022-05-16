//
//  SecondVC.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 4/4/22.
//

import Foundation
import UIKit

class TeamVC: UIViewController {
    
    var workingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        workingLabel.text = "Bajo Construcción"
        workingLabel.font = UIFont(name: "Avenir Next Condensed Regular", size: 24)
        workingLabel.textAlignment = NSTextAlignment.center
        workingLabel.numberOfLines = 0
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(workingLabel)
        workingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            workingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            workingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        
        
    }
    
}
