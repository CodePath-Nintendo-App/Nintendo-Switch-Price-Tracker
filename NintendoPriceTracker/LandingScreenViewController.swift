//
//  LandingScreenViewController.swift
//  NintendoPriceTracker
//
//  Created by Melchizedek Tetteh on 11/19/20.
//

import UIKit
import GoogleSignIn

class LandingScreenViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var signInButton: UIButton!
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //if any error stop and print the error
                if error != nil{
                    print(error ?? "google error")
                    return
                }
                
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
        UserDefaults.standard.set(true, forKey: "signedIn")
        UserDefaults.standard.set(givenName, forKey: "firstName")
        
        if(UserDefaults.standard.bool(forKey: "signedIn"))
        {
            performSegue(withIdentifier: "mainScreenSegue", sender: self)
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("Signed Out")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()

        // Do any additional setup after loading the view.
        //let googleSignInButton = GIDSignInButton()
        //googleSignInButton.center = view.center
        //view.addSubview(googleSignInButton)
    }
    
    @IBAction func OnSignInButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
