//
//  GameDetailsViewController.swift
//  NintendoPriceTracker
//
//  Created by Konstantin Novichenko on 12/11/20.
//
import youtube_ios_player_helper
import UIKit
import AlamofireImage
import Parse



class GameDetailsViewController: UIViewController {
    
    
    var games = [Game]()
    var ytDetails = [[String:Any]]()
    var videoId = String()
    var humbleUrl = "https://humblebundle.com"
    var allTimeLowPrice = "N/A"
    var currentPrice = "N/A"
    var plainsText = ""
    
    @IBAction func purchaseButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: humbleUrl)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func wishListButtton(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "Heart")
        {
            self.favoriteButton.setImage(UIImage(named: "heart_red"), for:  UIControl.State.normal)
            let game = PFObject(className: "Games")
            game["gameID"] = games[0].id
            game["title"] = games[0].title
            game["imageUrl"] = games[0].imageUrlString
            game["price"] = games[0].price
            game["discPrice"] = games[0].discPrice
            let imageData = self.posterImageView.image!.pngData()
            let file = PFFileObject(data: imageData!)
            game["image"] = file
            game["userID"] = PFUser.current()!
            game.saveInBackground { (success, error) in
                if(success){
                    
                }
                else{
                    print("error!")
                }
                
            }
        }
        else if (sender.currentImage == UIImage(named: "heart_red"))
        {
            let query = PFQuery(className: "Games")
            query.whereKey("title", equalTo: games[0].title)
            
            query.findObjectsInBackground { (objects, error) in
                    if error == nil,
                        let objects = objects {
                        for object in objects {
                            object.deleteInBackground()
                        }
                        self.favoriteButton.setImage(UIImage(named: "Heart"), for:  UIControl.State.normal)
                    }
            }
        }
        
        
        
    }
    
    @IBAction func notifyButton(_ sender: Any) {
        print("clicked notify")
    }
    
    @IBOutlet var playerView: YTPlayerView!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var priceNowLable: UILabel!
    @IBOutlet weak var priceLowLable: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(games[0].title)
        self.gameTitleLabel.text = games[0].title
        self.gameTitleLabel.sizeToFit()
        self.bannerImageView.af.setImage(withURL: URL(string: games[0].imageUrlString)!)
        
        self.priceNowLable.text = "Now: \(self.currentPrice)"
        self.priceLowLable.text = "Lowest: \(self.allTimeLowPrice)"
        
        let query = PFQuery(className: "Games")

        query.whereKey("title", equalTo: games[0].title)
        query.getFirstObjectInBackground { (posts, error) in
            if posts != nil {
                self.favoriteButton.setImage(UIImage(named: "heart_red"), for:  UIControl.State.normal)
                
            }
            else{
                self.favoriteButton.setImage(UIImage(named: "Heart"), for:  UIControl.State.normal)
            }
            
        }
        
                
        
        let plainsCharSet =  Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        
        let urlPlains = games[0].title.filter{plainsCharSet.contains($0)}
        
        
        let urlP = URL(string: "https://api.isthereanydeal.com/v01/game/prices/?key=94869c8af402b8b7eb925d986c9337d8b82d5d47&plains=\(urlPlains)&region=us")!
        let requestP = URLRequest(url: urlP, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let sessionP = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let taskP = sessionP.dataTask(with: requestP) { (data, response, error) in
                    // This will run when the network request returns
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let data = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        
                        //print dictionary
                        //print(dataDictionary)
                        let dataList = dataDictionary["data"] as! [String:Any]
                        var shopFound = false
                        
                        for dL in dataList
                        {
                            
                            let listOfDeals = dL.value as! [String:Any]
                            
                            for lOD in listOfDeals
                            {
                                
                                if(lOD.key == "list")
                                {
                                    let arrayListDeals = listOfDeals[lOD.key] as! [Any]
                                    if (arrayListDeals.isEmpty != true){
                                        //var counter = 0
                                        
                                        let dealList = listOfDeals[lOD.key] as! [NSObject]
                                        let storeDetails = dealList[0] as! [String:Any]
                                        let shop = storeDetails["shop"] as! [String:Any]
                                        if(shop["name"] as! String == "Humble Store")
                                        {
                                            self.humbleUrl = storeDetails["url"] as! String
                                            shopFound = true
                                            self.plainsText = dL.key
                                            break
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            if(shopFound)
                            {
                                break
                            }
                            
                        }
                        print(self.humbleUrl)
                        print(self.plainsText)

                        self.loadPrices()
                    }
                }
                taskP.resume()
        
        
        
        
        
        
        print("test---------------------------")
        
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890 +-=().!_")
        
        let term = games[0].title.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        // remove unbreakable space
        let removedSpecialSpace = term.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)

        
        let urlCleanString = removedSpecialSpace.filter{okayChars.contains($0)}
        
       
        let url = URL(string: "https://www.googleapis.com/youtube/v3/search?channelId=UCKy1dAqELo0zrOtPkf0eTMw&q=\(urlCleanString)&key=AIzaSyChGOHUTWczNJ6TqxnZvrZffKFczMS9-58")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
//        let task = session.dataTask(with: request) { (data, response, error) in
//                    // This will run when the network request returns
//                    if let error = error {
//                        print(error.localizedDescription)
//                    } else if let data = data {
//                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                        print("test-------------------------------------")
////                        print(dataDictionary["items"] as! [[String:Any]] )
//                        let videoDetails = dataDictionary["items"] as! [[String:Any]]
//
//                        let vidObj = videoDetails[0]["id"] as! [String:Any]
//                        let videoId = vidObj["videoId"] as! String
//                        self.playerView.load(withVideoId: videoId, playerVars:["playsinline":1])
//                    }
//                }
//                task.resume()
            
                let urlE = URL(string: "https://www.giantbomb.com/api/search/?api_key=9e316f22c617c9f2c3f0a39b1656f56545644a5e&format=json&limit=1&query=\(urlCleanString)&resources=game")!
                let requestE = URLRequest(url: urlE, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                let sessionE = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task2 = sessionE.dataTask(with: requestE) { (data, response, error) in
                   // This will run when the network request returns
                   if let error = error {
                      print(error.localizedDescription)
                   } else if let data = data {
                      let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let gameDetails = dataDictionary["results"] as! [[String:Any]]
                    //print(dataDictionary)
                    let  imageJSON  = gameDetails[0]["image"] as! [String:Any]
                    self.posterImageView.af.setImage(withURL: URL(string: imageJSON["medium_url"] as! String)!)
                    
                   }
                }
                task2.resume()
        playerView.load(withVideoId: "j0mg7GEIpio", playerVars:["playsinline":1])
        
        // Do any additional setup after loading the view.
    }
    
    func loadPrices()
    {
        if(self.plainsText != "")
        {
            let urlAT = URL(string: "https://api.isthereanydeal.com/v01/game/overview/?key=94869c8af402b8b7eb925d986c9337d8b82d5d47&plains=\(self.plainsText)&region=us")!
            let requestAT = URLRequest(url: urlAT, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let sessionAT = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            
            let taskAT = sessionAT.dataTask(with: requestAT) { (data, response, error) in
                        // This will run when the network request returns
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let data = data {
                            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                            
                            //print dictionary
                            
                            let list = dataDictionary["data"] as! [String:Any]
                            let priceData = list[self.plainsText] as! [String:Any]
                            let currentPriceD =  priceData["price"] as! [String:Any]
                            let lowPriceD =  priceData["lowest"] as! [String:Any]
                            //let game = results[0]
                            
                            if(self.currentPrice == "N/A")
                            {
                                
                                if(currentPriceD["price_formatted"] as! String != "")
                                {
                                    self.currentPrice = currentPriceD["price_formatted"] as! String
                                }
                                
                            }
                            
                            if(lowPriceD["price_formatted"] as! String != "N/A")
                            {
                                self.allTimeLowPrice = lowPriceD["price_formatted"] as! String
                            }
                            
                            
                            self.priceNowLable.text = "Now: " + self.currentPrice
                            self.priceLowLable.text = "Lowest: " + self.allTimeLowPrice
                            
                        }
                    }
                    taskAT.resume()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    struct GameDeal
    {
        var id: Int
        var priceNew: Float
        var allTimePrice: Float
        var storeUrl: String
        
    }

}
