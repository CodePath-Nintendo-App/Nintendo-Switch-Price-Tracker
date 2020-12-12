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
    
    @IBAction func purchaseButton(_ sender: Any) {
        print("test---------------------------")
        let url = URL(string: "https://api.isthereanydeal.com/v02/search/search/?key=94869c8af402b8b7eb925d986c9337d8b82d5d47&q=assassins%20creed%20odyssey&limit=20&strict=0")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
                    // This will run when the network request returns
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let data = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        
                        //print dictionary
                        print(dataDictionary)
                        let list = dataDictionary["data"] as! [String:Any]
                        let results =  list["results"] as! [[String:Any]]
                        let game = results[0]
//                        print(game["id"] as! [String:Any])

                    }
                }
                task.resume()
    }
    
    @IBAction func wishListButtton(_ sender: Any) {
        print("clicked wish")
        let game = PFObject(className: "games")
        game["title"] = gameTitleLabel.text
        let imageData = posterImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        game["image"] = file
    }
    
    @IBAction func notifyButton(_ sender: Any) {
        print("clicked notify")
    }
    
    @IBOutlet var playerView: YTPlayerView!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(games[0].title)
        self.gameTitleLabel.text = games[0].title
        self.gameTitleLabel.sizeToFit()
        self.bannerImageView.af.setImage(withURL: URL(string: games[0].imageUrlString)!)
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
