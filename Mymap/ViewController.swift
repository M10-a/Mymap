//
//  ViewController.swift
//  Mymap
//
//  Created by 浅野未央 on 2017/05/26.
//  Copyright © 2017年 mio. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController ,UITextFieldDelegate , MKMapViewDelegate{
                                         //プロトコル

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  
    //  テキストフィールドの通知を指定
  inputText.delegate = self
   
 
    // タップした時のアクションを追加
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
    dispMap.addGestureRecognizer(tapGesture)
    
    // MapView Delegate設定
    dispMap.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBOutlet weak var inputText: UITextField!

  @IBOutlet weak var dispMap: MKMapView!
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //Bool型
    textField.resignFirstResponder()
  
    let searchKeyword = textField.text
    //定数
    
    print(searchKeyword ?? "値が入っていません")
    
    let geocodeder = CLGeocoder()
    
    //入力された文字から情報を取得
    geocodeder.geocodeAddressString(searchKeyword!, completionHandler: { (Placemark:[CLPlacemark]?, error:Error?) in
      
      //位置情報を取得する場合1軒目をの情報を取り出す
      if let placemark = Placemark?[0] {
        
        if let tergetCoordnate = placemark.location?.coordinate{
          
          print(tergetCoordnate)
          
          let pin = MKPointAnnotation()
          
          pin.coordinate = tergetCoordnate
          
          pin.title = searchKeyword
          
          
          self.dispMap.addAnnotation(pin)
          
          self.dispMap.region = MKCoordinateRegionMakeWithDistance(tergetCoordnate ,500.0, 500.0 )
          

                  }
       
  
      }
  })
    return true
    
    }
  
  func mapTapped(_ sender: UITapGestureRecognizer){
    // タッチ終了か？
    if sender.state == .ended {
      // 画面上のタッチした座標を取得
      let tapPoint = sender.location(in: view)
      // タッチした座標からマップ上の緯度経度を取得
      let location = dispMap.convert(tapPoint, toCoordinateFrom: dispMap)
      print(location)
      
      //指定した緯度経度を半径100mで円を描く
      let pin = MKCircle(center: location, radius: 100.0)
      dispMap.removeOverlays(dispMap.overlays)
      dispMap.add(pin)
    }
  }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      //円のデザインを決める
      let circleRenderer = MKCircleRenderer(overlay: overlay)
      circleRenderer.strokeColor = UIColor.gray
      circleRenderer.fillColor = UIColor.gray.withAlphaComponent(0.5)
      circleRenderer.lineWidth = 1.0
      
      
      
      return circleRenderer
    }
    
  @IBAction func changeMapButtonAction(_ sender: Any) {
    if dispMap.mapType == .standard {
      dispMap.mapType = .satellite
    } else if dispMap.mapType == .satellite {
      dispMap.mapType = .hybrid
    } else if dispMap.mapType == .hybrid {
    dispMap.mapType = .satelliteFlyover
    } else if dispMap.mapType == .satelliteFlyover{
      dispMap.mapType = .hybridFlyover
    } else {
      dispMap.mapType = .standard
    }
    }
}
