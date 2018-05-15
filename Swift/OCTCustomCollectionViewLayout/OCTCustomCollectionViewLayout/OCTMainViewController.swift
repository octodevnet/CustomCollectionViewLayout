//
//  ViewController.swift
//  OCTCustomCollectionViewLayout
//
//  Created by dmitry.brovkin on 3/31/17.
//  Copyright © 2017 dmitry.brovkin. All rights reserved.
//

import UIKit

private let kReuseCellID = "reuseCellID"
private let kImgName = "img_"
private let kTotalImgs = 10

class OCTMainViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = collectionView.collectionViewLayout.description
        
        self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.collectionView.register(UINib(nibName: "\(OCTCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: kReuseCellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imgNumber = indexPath.item % kTotalImgs + 1
        let imageName = kImgName + "\(imgNumber)"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseCellID, for: indexPath) as! OCTCollectionViewCell
        cell.imgView!.image = UIImage(named: imageName)
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}

