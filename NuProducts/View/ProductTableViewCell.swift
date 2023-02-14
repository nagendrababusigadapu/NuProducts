//
//  ProductTableViewCell.swift
//  NuProducts
//
//  Created by Nagendra Babu on 13/02/23.
//

import UIKit
import SDWebImage

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbNailImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productRating: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var product:Product? {
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = false
        containerView.layer.shadowRadius = 4.0
        containerView.layer.shadowOpacity = 0.30
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateUI(){
        productTitle.text = product?.title
        productBrand.text = product?.brand
        productPrice.text = "\(product?.price ?? 0)".rupee
        productRating.text = "\(product?.rating ?? 0.0)"
        if let imageUrl = product?.thumbnail{
            thumbNailImageView.setImageFromUrl(url: imageUrl)
        }
    }
}

extension String {
    
    var rupee:String {
        get{
            "\u{20B9}" + " " + self
        }
    }
}

