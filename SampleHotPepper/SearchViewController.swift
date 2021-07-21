//
//  SearchViewController.swift
//  SampleHotPepper
//
//  Created by Makoto on 2021/07/20.
//

import UIKit
import MapKit
import PKHUD

final class SearchViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var latitudeValue = Double()
    var longitudeValue = Double()
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
        self.startUpdatingLocation()
        self.configureSubViews()
    }
    
    private func setUpViews() {
        
        self.view.backgroundColor = .white
        self.navigationItem.titleView = searchBar
        self.navigationItem.titleView?.frame = searchBar.frame
    }
    
    //位置情報を取得する許可画面。iOS14から更に精度の高いものに変更できるというアラートを出せる。
    private func startUpdatingLocation() {
        
        locationManager.requestAlwaysAuthorization()
        
        let status = CLAccuracyAuthorization.fullAccuracy
        if status == .fullAccuracy {
            
            locationManager.startUpdatingLocation()
        }
    }
    //　iOS13まで
    //        switch CLLocationManager.authorizationStatus() {
    //        case .notDetermined:
    //            locationManager.requestWhenInUseAuthorization()
    //        default:
    //            break
    //        }
    //        //現在地取得開始。
    //        locationManager.startUpdatingLocation()
}

extension SearchViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    private func configureSubViews() {
        
        locationManager.delegate = self
        //精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        //何メートルで更新するか。
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.userTrackingMode = .follow
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 一番最初に取ってきたもの。
        let location = locations.first
        //緯度
        let latitude = location?.coordinate.latitude
        //経度
        let longitude = location?.coordinate.longitude
        
        latitudeValue = latitude!
        longitudeValue = longitude!
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 何が選択されているかを取得する。
        switch manager.authorizationStatus {
        
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .notDetermined, .denied, .restricted:
            break
        default:
            print("Unhandled case")
        }
        
        switch manager.accuracyAuthorization {
        
        case .reducedAccuracy:
            break
        case .fullAccuracy:
            break
        default:
            print("This should not happen!")
        }
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
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Restaurant", bundle: nil)
        let restaurantViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantViewController") as! RestaurantViewController
        self.navigationController?.pushViewController(restaurantViewController, animated: true)
    }
}
