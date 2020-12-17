//
//  ViewController.swift
//  StickyScrollCollectionView
//
//  Created by Eshwar Ramesh on 17/12/20.
//  Copyright © 2020 Eshwar Ramesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var gridCollectionView: UICollectionView!
    @IBOutlet weak var gridLayout: StickyScrollCollectionView!
    
    var minDistFromCenter:CGFloat = CGFloat.greatestFiniteMagnitude
    var indexPathToScrollTo = IndexPath(row: 0, section: 0)
    let screenWidth = UIScreen.main.bounds.size.width
    
}

// MARK: - Collection view data source and delegate methods

extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.titleLabel.text = "row: \(indexPath.row) section :\(indexPath.section)"
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return CGSize(width: screenSize.width * 0.90, height: 200)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        scrollToMostVisibleCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToMostVisibleCell()
    }
    
    func scrollToMostVisibleCell() {
        let currentOffset = gridCollectionView.contentOffset.x
        var minDistFromCenter:CGFloat = CGFloat.greatestFiniteMagnitude
        var indexPathToScrollTo = IndexPath(row: 0, section: 0)
        let collectionViewCells = gridCollectionView.visibleCells
        for cell in collectionViewCells {
            let cellCenter = cell.center.x
            if let indexPath = gridCollectionView.indexPath(for: cell) {
                if indexPath.row == 0 { // doing this only for first row
                    // find screen center wrt collection view
                    let screenCenterWrtCollectionView = screenWidth/2 + currentOffset
                    let cellCenterWrtCollectionView = abs(screenCenterWrtCollectionView - cellCenter)
                    if cellCenterWrtCollectionView < minDistFromCenter {
                        
                        indexPathToScrollTo = indexPath
                        minDistFromCenter = cellCenterWrtCollectionView
                    }
                }
            }
        }
        gridCollectionView.scrollToItem(at: indexPathToScrollTo, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
}
