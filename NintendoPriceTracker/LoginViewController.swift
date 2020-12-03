//
//  LoginViewController.swift
//  NintendoPriceTracker
//
//  Created by Melchizedek Tetteh on 11/19/20.
//

import UIKit

class LoginViewController: UIViewController {


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
     
        
        //check if user name and pass word is in db
        
        self.performSegue(withIdentifier: "mainScreenSegue", sender: self)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
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
