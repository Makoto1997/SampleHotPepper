//
//  AnalyticsModel.swift
//  SampleHotPepper
//
//  Created by Makoto on 2021/07/22.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol DoneCatchDataProtocol {
    
    func catchData(arrayData:Array<ShopData>, resultCount:Int)
}

class AnalyticsModel {
    
    var latitudeValue: Double?
    var longitudeValue: Double?
    var urlString: String?
    var shopDataArray = [ShopData]()
    var doneCatchDataProtocol: DoneCatchDataProtocol?
    
    init(latitube: Double, longitube: Double, url: String) {
        
        latitudeValue = latitube
        longitudeValue = longitube
        urlString = url
    }
    
    func setData() {
        let encordeUrlString = urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(encordeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            print(response.debugDescription)
            
            switch response.result {
            
            case.success:
                do {
                    let json:JSON = try JSON(data: response.data!)
                    var totalHitCount = json["total_hit_count"].int
                    if totalHitCount! > 50 {
                        totalHitCount = 50
                    }
                    
                    for i in 0...totalHitCount! - 1 {
                        
                        if json["rest"][i]["latitube"] != "" && json["rest"][i]["longitube"] != "" && json["rest"][i]["url"] != "" && json["rest"][i]["name"] != "" && json["rest"][i]["image_url"]["shop_image1"] != "" {
                            
                            let shopData = ShopData(latitube: json["rest"][i]["latitube"].string, longitube: json["rest"][i]["longitube"].string, url: json["rest"][i]["url"].string, name: json["rest"][i]["name"].string, tel: json["rest"][i]["tel"].string, image: json["rest"][i]["image_url"]["shop_image1"].string)
                            
                            self.shopDataArray.append(shopData)
                            print(self.shopDataArray.debugDescription)
                        } else {
                            print("空のものがあります。")
                        }
                    }
                    
                    self.doneCatchDataProtocol?.catchData(arrayData: self.shopDataArray, resultCount: self.shopDataArray.count)
                } catch {
                    print("エラーです。")
                }
                break
                
            case.failure:
                break
            }
        }
    }
    //値をControllerに渡す。
}
