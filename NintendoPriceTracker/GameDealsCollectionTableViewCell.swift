//
//  GameDealsCollectionTableViewCell.swift
//  NintendoPriceTracker
//
//  Created by Konstantin Novichenko on 12/10/20.
//

import UIKit

protocol GameDealsCollectionTableViewCellDelegate: NSObjectProtocol{
    func didPressCell(sender: Int)
}

class GameDealsCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var delegate: GameDealsCollectionTableViewCellDelegate!
    
    static let identifier = "GameDealsCollectionTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "GameDealsCollectionTableViewCell",
                     bundle: nil)
    }
    
    func configure(with games: [Game])
    {
        self.games = games
        gameCollectionView.reloadData()
    }
    
    @IBOutlet var gameCollectionView: UICollectionView!
    
    var games = [Game]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gameCollectionView.register(GameDealsCollectionViewCell.nib(), forCellWithReuseIdentifier: GameDealsCollectionViewCell.identifier)
        gameCollectionView.delegate = self
        gameCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ gameCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ gameCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gameCollectionView.dequeueReusableCell(withReuseIdentifier: GameDealsCollectionViewCell.identifier, for: indexPath) as! GameDealsCollectionViewCell
        cell.configure(with: games[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        delegate.didPressCell(sender: indexPath.row)
    }
    
    func collectionView(_ gameCollectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = gameCollectionView.frame.size.width/4
        let height: CGFloat = gameCollectionView.frame.size.height/(1.5) //collectionView.frame.size.height
            return CGSize(width: width, height: height)

    }
    
    
   
}
