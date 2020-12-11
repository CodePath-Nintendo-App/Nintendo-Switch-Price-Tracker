//
//  GameDealsCollectionViewCell.swift
//  NintendoPriceTracker
//
//  Created by Konstantin Novichenko on 12/10/20.
//

import UIKit
import AlamofireImage

class GameDealsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var gameLabel: UILabel!
    @IBOutlet var gameImageView: UIImageView!
    @IBOutlet weak var discounterPriceLabel: UILabel!
    
    static let identifier = "GameDealsCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "GameDealsCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with game: Game)
    {
        print(game.discPrice)
      
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: game.price)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        self.gameLabel.attributedText = attributeString
        
        
        self.discounterPriceLabel.text = game.discPrice
        gameImageView.contentMode = .scaleAspectFill
        gameImageView.layer.masksToBounds = true
        gameImageView.layer.cornerRadius = gameImageView.bounds.width / 2
        self.gameImageView.af.setImage(withURL: URL(string: game.imageUrlString)!)
    }
}
