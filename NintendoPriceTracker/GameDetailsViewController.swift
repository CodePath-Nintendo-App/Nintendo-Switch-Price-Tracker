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
    
    @IBOutlet var playerView: YTPlayerView!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(games[0].title)
        self.gameTitleLabel.text = games[0].title
        self.gameTitleLabel.sizeToFit()
        self.bannerImageView.af.setImage(withURL: URL(string: games[0].imageUrlString)!)
        
        let url = URL(string: "https://www.googleapis.com/youtube/v3/search?channelId=UCKy1dAqELo0zrOtPkf0eTMw")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        
        playerView.load(withVideoId: "ur6I5m2nTvk", playerVars:["playsinline":1])
        
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
