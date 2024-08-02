//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


// WeatherViewControllerは、天気情報を表示するためのUIViewControllerサブクラスです。
class WeatherViewController: UIViewController {

    // UI部品のアウトレット
    // WeatherDataManagerインスタンスを作成して、天気情報の取得を管理
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    
    
    //MARK: Properties
    var weatherManager = WeatherDataManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 各デリゲートの設定
        locationManager.delegate = self
        weatherManager.delegate = self
        searchField.delegate = self
    }


}
 
//MARK:- TextField extension
// UITextFieldDelegateメソッドの実装
extension WeatherViewController: UITextFieldDelegate {
    
    // 検索ボタンがクリックされたときの処理
        @IBAction func searchBtnClicked(_ sender: UIButton) {
            // キーボードを閉じる
            searchField.endEditing(true)    //dismiss keyboard
            // 検索フィールドのテキストを出力
            print(searchField.text!)
            // 天気情報の検索
            searchWeather()
        }
    // 天気情報を検索するメソッド
        func searchWeather(){
            // テキストフィールドから都市名を取得し、天気情報の取得をリクエスト
            if let cityName = searchField.text{
                weatherManager.fetchWeather(cityName)
            }
        }
        
        // when keyboard return clicked
    // キーボードのリターンキーがクリックされたときの処理
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // キーボードを閉じる
            searchField.endEditing(true)    //dismiss keyboard
            // 検索フィールドのテキストを出力
            print(searchField.text!)
            // 天気情報の検索
            searchWeather()
            return true
        }
        
    // テキストフィールドが非選択になるときの処理
        // when textfield deselected
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            // by using "textField" (not "searchField") this applied to any textField in this Controller(cuz of delegate = self)
            // テキストフィールドにテキストが入力されている場合は、編集を終了
            if textField.text != "" {
                return true
                // テキストフィールドが空の場合は、プレースホルダーを設定して編集を終了しない
            }else{
                textField.placeholder = "Type something here"
                return false            // check if city name is valid
            }
        }
        
        // when textfield stop editing (keyboard dismissed)
    // テキストフィールドの編集が終了したときの処理
        func textFieldDidEndEditing(_ textField: UITextField) {
            // ここではテキストフィールドの内容をクリアする処理などが可能ですが、コメントアウトされています
                    // searchField.text = ""   // clear textField
    //        searchField.text = ""   // clear textField
        }
}

//MARK:- View update extension
// WeatherManagerDelegateメソッドの実装
extension WeatherViewController: WeatherManagerDelegate {
    
    // 天気情報を更新するメソッド
    func updateWeather(weatherModel: WeatherModel){
        // メインスレッドでUIの更新を行う
        DispatchQueue.main.sync {
            // ラベルと画像を更新
            temperatureLabel.text = weatherModel.temperatureString
            cityLabel.text = weatherModel.cityName
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
        }
    }
    
    // エラーが発生したときの処理
    func failedWithError(error: Error){
        print(error)
    }
}

// MARK:- CLLocation
// CLLocationManagerDelegateメソッドの実装
extension WeatherViewController: CLLocationManagerDelegate {
    
    // 現在地ボタンがクリックされたときの処理
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        // Get permission
        // 位置情報の使用許可をリクエスト
        locationManager.requestWhenInUseAuthorization()
        // 現在地の取得をリクエスト
        locationManager.requestLocation()
    }
    
    // 位置情報が更新されたときの処理
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 最後の位置情報を取得
        if let location = locations.last {
            // 緯度と経度を取得し、天気情報の取得をリクエスト
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat, lon)
        }
    }
    // 位置情報の取得に失敗したときの処理
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
