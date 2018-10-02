//
//  Menu.swift
//  iVote
//
//  Created by BFar on 7/30/18.
//  Copyright © 2018 iVote. All rights reserved.
//

import Foundation
import UIKit

class MenuVC: UIViewController {
    //MARK: Variables & Constants
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** Dismiss View Controller */
    @IBAction func dismissVC() {
        self.dismiss(animated: true) {}
    }
    
}


/** Cell displaying a menu item. */
class MenuCell : UICollectionViewCell {
    
    //MARK: Variables & Constants
    
    /** Menu item title. */
    @IBOutlet var title: UILabel!
}


extension MenuVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Collection View Datasource, Delegate & Flow Layout
    /** NUM SECTIONS */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /** NUM ITEMS */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    /** CELL */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItem",
                                                      for: indexPath) as! MenuCell
        
        //#HARDCODE Titles
        switch indexPath.row {
        case 0:
            cell.title.text = "Home"
        case 1:
            cell.title.text = "Settings"
        case 2:
            cell.title.text = "Election Resources"
        case 3:
            cell.title.text = "About iVote"
        
        default:
            
            break
        }
        
        return cell
    }
    
    
    /** SIZE */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 66
        
        return CGSize(width: width, height: height)
    }
    
    /** SELECTION */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.dismissVC()
        case 1:
            self.performSegue(withIdentifier: "OpenSettings", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "OpenElectionResources", sender: nil)
        case 3:
            self.performSegue(withIdentifier: "OpenAbout", sender: nil)
        default:
            break
        }
        
    }
    
}

