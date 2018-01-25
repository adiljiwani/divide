//
//  ChooseGroupIconVC.swift
//  divide
//
//  Created by Adil Jiwani on 2018-01-24.
//  Copyright © 2018 Adil Jiwani. All rights reserved.
//

import UIKit

class ChooseGroupIconVC: UIViewController {
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    var imageArray = [UIImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ChooseGroupIconVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupIconCell", for: indexPath) as? GroupIconCell else {return UICollectionViewCell()}
        cell.configureCell(image: imageArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let createGroupVC = storyboard?.instantiateViewController(withIdentifier: "createGroupVC") as? CreateGroupVC else {return}
        createGroupVC.setGroupIcon(icon: imageArray[indexPath.row])
        present(createGroupVC, animated: true, completion: nil)
    }
}