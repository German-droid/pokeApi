//
//  AuthVC.swift
//  pokeApi
//
//  Created by German Fuentes Ripoll on 16/5/22.
//

import Foundation
import UIKit
import FirebaseAnalytics
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import GoogleSignIn

enum GIDSignInErrorCode : NSInteger {
    case unknown = -1
    case keychain = -2
    case hasNoAuthInKeychain = -4
    case canceled = -5
    case EMM = -6
    case noCurrentUser = -7
    case scopesAlreadyGranted = -8
}

class AuthVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var registrarButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var accederButton: UIButton!
    @IBOutlet weak var mainStackView: UIStackView!
    
    private let emailPattern = #"^\S+@\S+\.\S+$"#
    
    @IBAction func regButtonPressed(_ sender: Any) {
        
        guard checkEmail(), checkPass(), checkUsername() else {return}
        guard let email = mailTextField?.text, let pass = passTextField?.text, let username = usernameTextField?.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: pass) { result, error in
            guard let _ = result, error == nil else {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        case .emailAlreadyInUse:
                            CustomToast.show(message: "Ya existe una cuenta con ese correo", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                        default:
                            print("Create User Error: \(errCode)")
                    }
                }
                return
            }
            
            Database.database().reference().child("usuarios").child(result!.user.uid).child("username").setValue(username)
            
            CustomToast.show(message: "Registro completado con éxito", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
            
        }
    }
    
    @IBAction func accButtonPressed(_ sender: Any) {
        guard checkEmail(), checkPass() else {return}
        guard let email = mailTextField?.text, let pass = passTextField?.text else {return}
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: pass)
        
        
        
        Auth.auth().signIn(with: credential) { result, error in
            guard let _ = result, error == nil else {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        case .userNotFound:
                            CustomToast.show(message: "No existe ninguna cuenta con dicho correo", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                        case .wrongPassword:
                            CustomToast.show(message: "Credenciales incorrectas", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                        default:
                            print("Create User Error: \(errCode)")
                    }
                }
                return
            }
        
            let vc = MainController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @IBAction func googleButtonPressed(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
    
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

            if let error = error {
                let errCode = GIDSignInErrorCode(rawValue: error._code)
                print(error)
                switch errCode {
                case .canceled:
                    CustomToast.show(message: "Inicio de sesión cancelado", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                default:
                    CustomToast.show(message: "Error durante el inicio de sesión", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                }
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

            if let user = Auth.auth().currentUser {
                user.link(with: credential, completion: { authResult, error in
                    if let error = error {
                        print(error)
                        CustomToast.show(message: "Error durante el inicio de sesión", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                        
                        return
                    }
                    // User is signed in
                    let vc = MainController()
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            } else {
                self.useCredential(credential: credential)

            }
           
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if checkIfLogged() {
            let vc = MainController()
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func checkIfLogged() -> Bool {
        let user = Auth.auth().currentUser
        print(user ?? "no user")
        if let _ = user {
            return true
        } else {
            return false
        }
    }
    
    // Validation Funcs
    func checkEmail() -> Bool {
        
        guard let email = mailTextField?.text, !email.isEmpty else {
            CustomToast.show(message: "Correo Vacio", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
            
            return false
        }
        
        guard email.range(of: emailPattern, options: .regularExpression) != nil else {
            CustomToast.show(message: "Correo no Válido", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
            
            return false
        }
        
        return true
    }
    
    func checkPass() -> Bool {
        
        guard let pass = passTextField?.text, !pass.isEmpty else {
            CustomToast.show(message: "Contraseña Vacia", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
            
            return false
        }
        
        return true
    }
    
    func checkUsername() -> Bool {
        
        guard let username = usernameTextField?.text, !username.isEmpty else {
            CustomToast.show(message: "Usuario Vacio", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
            
            return false
        }
        
        return true
    }
    
    // Credential function
    func useCredential(credential: AuthCredential ) {
        
        print("dentro funcion")
        print(Auth.auth().currentUser ?? "no user")
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print(error)
                CustomToast.show(message: "Error durante el inicio de sesión", bgColor: .black, textColor: .white, labelFont: UIFont(name: "Puzzle-Tale-Pixel-BG", size: 25) ?? .boldSystemFont(ofSize: 25), showIn: .top, controller: self)
                
                return
            }
            guard let result = authResult else {return}
            Database.database().reference().child("usuarios").child(result.user.uid).child("username").getData { error, snapshot in
                if type(of:snapshot.value!) == NSNull.self {
                    print("dentro null Username")
                    guard self.checkUsername() else {
                        do {
                            try Auth.auth().signOut()
                        } catch {
                            print("Error, no user logged")
                        }
                        return
                    }
                    guard let username = self.usernameTextField?.text else {return}
                    Database.database().reference().child("usuarios").child(result.user.uid).child("username").setValue(username)
                    let vc = MainController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = MainController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
    }

}
