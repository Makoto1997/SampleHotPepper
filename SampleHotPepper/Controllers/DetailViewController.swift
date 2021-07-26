//
//  DetailViewController.swift
//  SampleHotPepper
//
//  Created by Makoto on 2021/07/20.
//

import UIKit
import WebKit
import SDWebImage

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    var url = String()
    var imageURLSting = String()
    var name = String()
    var tel = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImageView.sd_setImage(with: URL(string: imageURLSting), completed: nil)
        
        let request = URLRequest(url: URL(string: url)!)
        webView.load(request)
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
        
        UIApplication.shared.open(URL(string: "//\(tel)")!, options: [:], completionHandler: nil)
    }
}
