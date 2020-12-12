//
//  MainViewController.swift
//  NintendoPriceTracker
//
//  Created by Melchizedek Tetteh on 12/3/20.
//

import UIKit
import GoogleSignIn
import AlamofireImage

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, GameDealsCollectionTableViewCellDelegate {
    
    
    func didPressCell(sender: Int) {
        //let vc = GameDetailsViewController()
        chosenGameIndex = sender
        performSegue(withIdentifier: "GameDetailsSegue", sender: self)
        //vc.games.append(gamesWithPrices[sender])
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onEnterTriggered(_ sender: Any) {
        let textString = self.searchBar.text! as String
        
        if(textString != "")
        {
            let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890 +-=().!_")
            
            let term = textString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            
            // remove unbreakable space
            let removedSpecialSpace = term.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)

            
            let urlCleanString = removedSpecialSpace.filter{okayChars.contains($0)}
            
            let urlE = URL(string: "https://www.giantbomb.com/api/search/?api_key=9e316f22c617c9f2c3f0a39b1656f56545644a5e&format=json&limit=20&query=\(urlCleanString)&resources=game")!
            let requestE = URLRequest(url: urlE, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let sessionE = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task2 = sessionE.dataTask(with: requestE) { (data, response, error) in
               // This will run when the network request returns
               if let error = error {
                  print(error.localizedDescription)
               } else if let data = data {
                  let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let gameDetails = dataDictionary["results"] as! [[String:Any]]
                if(gameDetails.isEmpty == false)
                {
                    var indexOfSwitch = -1
                    var counterLoop = 0
                    for gD in gameDetails
                    {
                        let gDPlatforms = gD["platforms"]  as! [[String:Any]]
                        
                        
                        for platform in gDPlatforms
                        {
                            if(platform["name"] as! String == "Nintendo Switch")
                            {
                                indexOfSwitch = counterLoop
                                break
                            }
                        }
                        
                        if(indexOfSwitch != -1)
                        {
                            break
                        }
                        counterLoop = counterLoop + 1
                    }
                    
                    if(indexOfSwitch != -1)
                    {
                        let  imageJSON  = gameDetails[indexOfSwitch]["image"] as! [String:Any]
                        
                        let newGame = Game(id: 0, title: gameDetails[indexOfSwitch]["name"] as! String, price: "nil", discPrice: "nil", imageUrlString: imageJSON["screen_large_url"] as! String)
                        self.gameFromSearch.removeAll()
                        self.gameFromSearch.append(newGame)
                        self.performSegue(withIdentifier: "GameSearchSegue", sender: self)
                    }
                    else{
                        let alert = UIAlertController(title: "No Results", message: "It's recommended to seacrh for the official game name", preferredStyle: .alert)

                        
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

                        self.present(alert, animated: true)
                    }
                    
                    
                }
                else{
                    let alert = UIAlertController(title: "No Results", message: "It's recommended to seacrh for the official game name", preferredStyle: .alert)

                    
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

                    self.present(alert, animated: true)
                }
                
                
               }
            }
            task2.resume()
        }
        
        
        
        self.searchBar.text = ""
    }
    
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var horizontalTableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    var games = [[String:Any]]()
    var gamesWithPrices = [Game]()
    var chosenGameIndex = Int()
    var gameFromSearch = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.layer.cornerRadius = 15.0
        searchBar.layer.borderWidth = 2.0
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.clipsToBounds = true
        searchBar.attributedPlaceholder = NSAttributedString(string: "Search Game",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        horizontalTableView.register(GameDealsCollectionTableViewCell.nib(), forCellReuseIdentifier: GameDealsCollectionTableViewCell.identifier)
        horizontalTableView.dataSource = self
        horizontalTableView.delegate =  self
        horizontalTableView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    
        let url = URL(string: "https://ec.nintendo.com/api/US/en/search/sales?count=30&offset=0")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

            self.games = dataDictionary["contents"] as! [[String:Any]]
            
            
            
            
            self.tableView.reloadData()
            self.loadGamePrices()
            
            // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data
            //print(self.games[0]["formal_name"] ?? "no name")
           }
        }
        
        //Looks for single or multiple taps.
             let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
        
        task.resume()
    }
    
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func loadGamePrices()
    {
        for game in self.games
        {
            let priceUrl = URL(string: "https://api.ec.nintendo.com/v1/price?country=US&ids=\(game["id"] ?? 70010000015154)&lang=en" )!
            let priceRequest = URLRequest(url: priceUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let priceSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let priceTask = priceSession.dataTask(with: priceRequest) { (data, response, error) in
                // This will run when the network request returns
                if let error = error {
                   print(error.localizedDescription)
                } else if let data = data {
                   let priceDataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    //let gameName = game["formal_name"] as! String
                    //print(game["formal_name"] as! String)
                    //print(game["id"] as! Int)
                    //let currentGamePrice = priceDataDictionary["prices"] as! [[String:Any]]
                    //print(priceDataDictionary)
                    //let gameId = game["id"] as! String
                    let currentGamePrice = priceDataDictionary["prices"] as! [[String:Any]]
                    let regularPriceDictionary = currentGamePrice[0]["regular_price"] as AnyObject
                    let discountPriceDictionary = currentGamePrice[0]["discount_price"] as AnyObject
                    let regularPrice = regularPriceDictionary["amount"] as! String
                    let discountPrice =  discountPriceDictionary["amount"] as! String
                    let gameImageUrlString = game["hero_banner_url"] as! String
                    
                    let currentGame = Game(id: game["id"] as! Int, title: game["formal_name"] as! String, price: regularPrice, discPrice: discountPrice, imageUrlString: gameImageUrlString)
                    
                    self.gamesWithPrices.append(currentGame)
                    
                    //let discPrice = currentGamePrice[0]["discounted_price"] as! [String:Any]
                    //print(discPrice["amount"] ?? "$0.00")
                    //let gamePrice =
                    self.horizontalTableView.reloadData()
                }
            }
            
            priceTask.resume()
            //self.models.append(Model(text: gameName, imageName: "Sign_Up_Pikmin"))
        }
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tableView)
        {
            return games.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.tableView)
        {
            let cell = UITableViewCell()
            print(indexPath.row)
            let game = games[indexPath.row]
            let title = game["formal_name"] as! String
            
            cell.textLabel!.text = title
            return cell
        }
        else if(tableView == horizontalTableView)
        {
            let cell = horizontalTableView.dequeueReusableCell(withIdentifier: GameDealsCollectionTableViewCell.identifier, for: indexPath) as! GameDealsCollectionTableViewCell
           
            print(indexPath.row)
            cell.delegate = self
            cell.configure(with: gamesWithPrices)
            return cell
            
                
        }
        
        return UITableViewCell()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "GameDetailsSegue")
        {
            let gameDetailsViewController = segue.destination as! GameDetailsViewController
            gameDetailsViewController.games.append(gamesWithPrices[chosenGameIndex])
        }
        else if(segue.identifier == "signOutSegue")
        {
            GIDSignIn.sharedInstance()?.signOut()
        }
        else if(segue.identifier == "GameSearchSegue")
        {
            let gameDetailsViewController = segue.destination as! GameDetailsViewController
            gameDetailsViewController.games.append(gameFromSearch[0])
        }
        
        
    }
    
    

}

struct Game {
    let id: Int
    let title: String
    let price: String
    let discPrice: String
    let imageUrlString: String
    init(id: Int, title: String, price: String, discPrice: String, imageUrlString: String)
    {
        self.id = id
        self.title = title
        self.price = price
        self.discPrice = discPrice
        self.imageUrlString = imageUrlString
    }
    
}
