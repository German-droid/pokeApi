//
//  ViewController.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 4/4/22.
//

import UIKit
import FirebaseAuth

class MainController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create instance of view controllers
        
        
        
        let pokedexVC = UINavigationController(rootViewController: PokedexVC())
        let teamVC = UINavigationController(rootViewController: TeamVC())
        let battleVC = UINavigationController(rootViewController: BattleVC())
        
        
        
        // set title
        pokedexVC.title = "Pokedex"
        teamVC.title = "Mi Equipo"
        battleVC.title = "Combate"
        
        // assign  view controllers to tab bar
        self.setViewControllers([teamVC,pokedexVC,battleVC], animated: true)
        self.selectedIndex = 1
        
        // swipe funcionallity
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        

        // icons
        guard let items = self.tabBar.items else {return}
        
        let images = ["team","pokedex","battle"]
        
        for (i, item) in items.enumerated() {
            item.image = UIImage(named: images[i])
            item.selectedImage = UIImage(named: images[i]+"-fill")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        let selectedColor = UIColor.rgb(red: 255, blue: 255, green: 255, alpha: 1)
        let normalColor = UIColor.rgb(red: 255, blue: 255, green: 255, alpha: 0.6)
        
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()

        tabBarItemAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: normalColor,
            NSAttributedString.Key.font: UIFont(name: "Pokemon-Pixel-Font", size: 23)!,
            ]
        tabBarItemAppearance.normal.iconColor = normalColor
        tabBarItemAppearance.selected.iconColor = selectedColor

        tabBarItemAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: selectedColor,
            NSAttributedString.Key.font: UIFont(name: "Pokemon-Pixel-Font", size: 23)!,
            ]
        
        tabBarAppearance.backgroundColor = .mainPink()
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance

        view.backgroundColor = .white
        tabBar.backgroundColor = .white
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
    }
    
    
    @objc func handleSwipeGesture(_ gesture:UISwipeGestureRecognizer) {
        // asegurarme de que tienen valor
        guard let viewCount = self.viewControllers?.count else {return}
        if (gesture.direction == .left && (self.selectedIndex+1) < viewCount) {
            self.selectedIndex += 1
        } else if (gesture.direction == .right && (self.selectedIndex-1) >= 0) {
            self.selectedIndex -= 1
        }
    }
    
    

}

/*extension MainController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            
            if let fromView = tabBarController.selectedViewController?.view,
                let toView = viewController.view, fromView != toView,
                let controllerIndex = self.viewControllers?.firstIndex(of: viewController) {
                
                let viewSize = fromView.frame
                let scrollRight = controllerIndex > tabBarController.selectedIndex
                
                // Avoid UI issues when switching tabs fast
                if fromView.superview?.subviews.contains(toView) == true { return false }
                
                fromView.superview?.addSubview(toView)
                
                let screenWidth = UIScreen.main.bounds.size.width
                toView.frame = CGRect(x: (scrollRight ? screenWidth : -screenWidth), y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)

                UIView.animate(withDuration: 0.25, delay: TimeInterval(0.0), options: [.curveEaseOut, .preferredFramesPerSecond60], animations: {
                    fromView.frame = CGRect(x: (scrollRight ? -screenWidth : screenWidth), y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)
                    toView.frame = CGRect(x: 0, y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)
                }, completion: { finished in
                    if finished {
                        fromView.removeFromSuperview()
                        tabBarController.selectedIndex = controllerIndex
                    }
                })
                return true
            }
            return false
        }
}*/
