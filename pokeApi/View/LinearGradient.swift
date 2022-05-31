//
//  LinearGradient.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 9/5/22.
//

import UIKit

class LinearGradient: UIView {

    private var gradientLayer = CAGradientLayer()
    private var vertical: Bool = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        gradientLayer.frame = self.bounds

        if gradientLayer.superlayer == nil {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1): CGPoint(x: 1, y: 0)
            gradientLayer.colors = [UIColor.systemRed.cgColor,UIColor.systemOrange.cgColor,UIColor.systemYellow.cgColor,UIColor.systemMint.cgColor,UIColor.systemTeal.cgColor,UIColor.systemCyan.cgColor,UIColor.systemBlue.cgColor]
            gradientLayer.locations = [0.0,0.100,0.300,0.4,0.600,0.800,1.0]
            self.layer.insertSublayer(gradientLayer, at: 0)
            
        }

    }
    

}
