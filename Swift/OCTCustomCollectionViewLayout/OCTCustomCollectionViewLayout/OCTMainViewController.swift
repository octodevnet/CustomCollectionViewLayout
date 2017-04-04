//
//  ViewController.swift
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 3/31/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

import UIKit

private let kReuseCellID = "reuseCellID"

class OCTMainViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:kReuseCellID)
        title = collectionView.collectionViewLayout.description
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseCellID, for: indexPath)
        cell.contentView.backgroundColor = UIColor.green
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

