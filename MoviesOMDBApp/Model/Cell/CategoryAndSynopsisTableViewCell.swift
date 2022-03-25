//
//  CategoryAndSynopsisTableViewCell.swift
//  MoviesOMDBApp
//
//  Created by NISHANT RANJAN on 26/3/22.
//

import Foundation
import UIKit

class CategoryAndSynopsisTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryDetails: UILabel!
    @IBOutlet weak var sypnopisDetails: UILabel!
    @IBOutlet weak var scoreDetails: UILabel!
    @IBOutlet weak var reviewDetails: UILabel!
    @IBOutlet weak var popularityDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
