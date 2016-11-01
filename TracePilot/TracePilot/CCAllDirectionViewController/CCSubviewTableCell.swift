//
//  CCSubviewTableCell.swift
//  TracePilot
//
//  Created by He, Changchen on 10/28/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import SnapKit

class CCSubviewTableCell: UITableViewCell {

    var collectionView:UICollectionView?
    var rowIndex:Int?

    private let kCellReuse : String = "PackCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.isPagingEnabled = true
        self.contentView.addSubview(collectionView!)
        
        collectionView?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
        }
        
        self.collectionView?.register(CCPage.self, forCellWithReuseIdentifier: kCellReuse)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setMiddle(){
        collectionView?.selectItem(at: IndexPath.init(row: 1, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.left)
    }

}

extension CCSubviewTableCell : UICollectionViewDataSource {
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CCAllDicctionViewFactory.sharedInstance.column
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"PackCell", for: indexPath) as! CCPage
        if let controller = CCAllDicctionViewFactory.sharedInstance.getVCAt(row: self.rowIndex!, col: indexPath.row)
        {
            print("row\(self.rowIndex!) col:\(indexPath.row)")
            cell.customView = controller.view
            cell.load()
        }
        return cell
    }
}

extension CCSubviewTableCell : UICollectionViewDelegate {
    
}



extension CCSubviewTableCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

}
