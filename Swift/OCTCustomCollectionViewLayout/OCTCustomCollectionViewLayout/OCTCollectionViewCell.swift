//
//  OCTCollectionViewCell.swift
//  OCTCustomCollectionViewLayout
//
//  Created by fantom on 4/4/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

import UIKit

class OCTCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = 8
        imgView.clipsToBounds = true
    }

}
