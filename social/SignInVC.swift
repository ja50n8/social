//
//  SignInVC.swift
//  social
//
//  Created by Jason Bell on 21/06/2017.
//  Copyright © 2017 Cold Entertainment. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("JASON: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
        
    }

    

    @IBAction func faceBookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("JASON: Unable to authenticate with Facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("JASON: User cancelled Facebook authentication")
            } else {
                print("JASON: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("JASON: Unable to authenticate with Firebase = \(String(describing: error))")
            } else {
                print("JASON: Successfully authenticated with Firebase")
                if let user = user {
                    self.compelteSignIn(id: user.uid)
                }
            }
        })
            
    }

    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("JASON: Email user authenticated with Firebase")
                    if let user = user {
                        self.compelteSignIn(id: user.uid)
                    }
                    
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                        print("JASON: Email user unable to authenticate with Firebase")
                        } else {
                            print("JASON: Email user successfully authenticated with Firebase")
                        }
                        print("\(user, error)")
                        if let user = user {
                            self.compelteSignIn(id: user.uid)
                        }
                    
                    })
                }
            })
        }
        
    }
    
    func compelteSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("JASON: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    
}









