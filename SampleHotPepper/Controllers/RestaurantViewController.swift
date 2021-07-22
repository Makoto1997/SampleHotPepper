//
//  RestaurantViewController.swift
//  SampleHotPepper
//
//  Created by Makoto on 2021/07/20.
//

import UIKit

final class RestaurantViewController: UIViewController {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func setUpViews() {
        // 電話ボタン
        self.callButton.backgroundColor = .blue
        self.callButton.tintColor = .white
        self.callButton.layer.masksToBounds = true
        self.callButton.layer.cornerRadius = 80 / 2
        self.callButton.layer.position = CGPoint(x: self.view.bounds.width - 20, y:self.view.bounds.height - 100)
    }
    
    @IBAction func call(_ sender: Any) {
        
    }
}
