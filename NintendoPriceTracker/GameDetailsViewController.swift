//
//  GameDetailsViewController.swift
//  NintendoPriceTracker
//
//  Created by Konstantin Novichenko on 12/11/20.
//
import youtube_ios_player_helper
import UIKit
import AlamofireImage

class GameDetailsViewController: UIViewController {
    
    
    var games = [Game]()
    var ytDetails = [[String:Any]]()
    var videoId = String()
    
    @IBOutlet var playerView: YTPlayerView!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(games[0].title)
        self.gameTitleLabel.text = games[0].title
        self.gameTitleLabel.sizeToFit()
        self.bannerImageView.af.setImage(withURL: URL(string: games[0].imageUrlString)!)
        
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        let term = games[0].title.filter{okayChars.contains($0)}
        
        print(term)
        let url = URL(string: "https://www.googleapis.com/youtube/v3/search?channelId=UCKy1dAqELo0zrOtPkf0eTMw&q="+term+"&key=AIzaSyChGOHUTWczNJ6TqxnZvrZffKFczMS9-58")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
                    // This will run when the network request returns
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let data = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        print("test-------------------------------------")
//                        print(dataDictionary["items"] as! [[String:Any]] )
                        let videoDetails = dataDictionary["items"] as! [[String:Any]]
                        let vidObj = videoDetails[0]["id"] as! [String:Any]
                        let videoId = vidObj["videoId"] as! String
                        self.playerView.load(withVideoId: videoId, playerVars:["playsinline":1])
                    }
                }
                task.resume()
        
        
//        playerView.load(withVideoId: "j0mg7GEIpio", playerVars:["playsinline":1])
        
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
