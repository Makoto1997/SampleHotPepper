//
//  SearchViewController.swift
//  SampleHotPepper
//
//  Created by Makoto on 2021/07/20.
//

import UIKit

class SearchViewController: UIViewController {
    //この中でselfを呼べないのでlazyを使用しタイミングを遅らせる。
    lazy var searchBar: UISearchBar = {
       
       let sb = UISearchBar()
       sb.placeholder = "検索"
       sb.delegate = self
       
       return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpViews()
    }
    
    private func setUpViews() {
        
        self.view.backgroundColor = .white
        self.navigationItem.titleView = searchBar
        self.navigationItem.titleView?.frame = searchBar.frame
    }
}

extension SearchViewController: UISearchBarDelegate {
    //検索を始めた時のメソッド
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    //        キャンセルボタンを有効にする
        searchBar.showsCancelButton = true
    }
    // キャンセルボタンが押された時のメソッド
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    //    検索ボタンを押した時のメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        //        api通信を呼ぶ
    }
}
