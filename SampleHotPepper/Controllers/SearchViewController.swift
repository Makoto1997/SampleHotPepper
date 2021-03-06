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
    var apikey = "c8df44b0aa6625f6"
    
    var shopDataArray = [ShopData]()
    var totalHitCount = Int()
    var urlArray = [String]()
    var imageStringArray = [String]()
    var nameStringArray = [String]()
    var telArray = [String]()
    var annotation = MKPointAnnotation()
    var indexNumber = Int()
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
    
    func addAnnotation(shopData:[ShopData]) {
        
        removeArray()
        for i in 0...totalHitCount - 1 {
            print(i)
            annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(shopDataArray[i].latitube!)!, CLLocationDegrees(shopDataArray[i].longitube!)!)
            //タイトル、サブタイトル
            annotation.title = shopData[i].name
            annotation.subtitle = shopData[i].tel
            urlArray.append(shopData[i].url!)
            imageStringArray.append(shopData[i].image!)
            nameStringArray.append(shopData[i].name!)
            telArray.append(shopData[i].tel!)
            mapView.addAnnotation(annotation)
        }
    }
    
    func removeArray() {
        //ピンを削除する。
        mapView.removeAnnotation(mapView.annotations as! MKAnnotation)
        
        urlArray = []
        imageStringArray = []
        nameStringArray = []
        telArray = []
    }
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
    //ピンをタップした時に呼ばれる。
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        //情報をもとに画面遷移。
        indexNumber = Int()
        //何番目か。
        if nameStringArray.firstIndex(of: (view.annotation?.title)!!) != nil {
            
            print(indexNumber)
            let storyboard:UIStoryboard = UIStoryboard(name: "Detail", bundle: nil)
            let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailViewController.url = urlArray[indexNumber]
            detailViewController.imageURLSting = imageStringArray[indexNumber]
            detailViewController.name = nameStringArray[indexNumber]
            detailViewController.tel = telArray[indexNumber]
            
            
            self.navigationController?.pushViewController(detailViewController, animated: true)
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
        HUD.show(.progress)
        //        api通信を呼ぶ
        let urlString = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apikey)&latitude=\(latitudeValue)&longitude=\(longitudeValue)&range=3&hit_per_page=50&freeword=\(searchBar.text!)"
        let analyticsModel = AnalyticsModel(latitube: latitudeValue, longitube: longitudeValue, url: urlString)
        
        analyticsModel.doneCatchDataProtocol = self
        analyticsModel.setData()
    }
}

extension SearchViewController: DoneCatchDataProtocol {
    
    func catchData(arrayData: Array<ShopData>, resultCount: Int) {
        
        HUD.hide()
        shopDataArray = arrayData
        totalHitCount = resultCount
        
        addAnnotation(shopData: shopDataArray)
    }
}
