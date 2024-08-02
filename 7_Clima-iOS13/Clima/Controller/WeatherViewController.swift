//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit // iOSアプリのUIを構築するためのフレームワーク
import CoreLocation // 位置情報を取得するためのフレームワーク

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView! // 天気の状態を示す画像を表示
    @IBOutlet weak var temperatureLabel: UILabel! // 温度を表示するラベル
    @IBOutlet weak var cityLabel: UILabel! // 都市名を表示するラベル
    @IBOutlet weak var searchField: UITextField! // ユーザーが都市名を入力するためのテキストフィールド
    
    //MARK: Properties
    var weatherManager = WeatherDataManager() // 天気データを管理するオブジェクト
    let locationManager = CLLocationManager() // 位置情報を管理するオブジェクト
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self // 位置情報の更新を受け取るためのデリゲート設定
        weatherManager.delegate = self // 天気データの更新を受け取るためのデリゲート設定
        searchField.delegate = self // テキストフィールドのイベントを受け取るためのデリゲート設定
    }
}

//MARK:- TextField extension
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        searchField.endEditing(true)    // キーボードを閉じる
        print(searchField.text!) // 入力された都市名をデバッグ出力
        searchWeather() // 入力された都市名で天気情報を検索
    }
    
    func searchWeather() {
        if let cityName = searchField.text {
            weatherManager.fetchWeather(cityName) // 入力された都市名で天気データを取得
        }
    }
    
    // キーボードのリターンキーが押されたときに呼ばれる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)    // キーボードを閉じる
        print(searchField.text!) // 入力された都市名をデバッグ出力
        searchWeather() // 入力された都市名で天気情報を検索
        return true
    }
    
    // テキストフィールドの編集が終わる前に呼ばれる
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // テキストフィールドが空でないかを確認
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something here" // プレースホルダーを設定
            return false // テキストフィールドが空の場合は編集を終了しない
        }
    }
    
    // テキストフィールドの編集が終わったときに呼ばれる
    func textFieldDidEndEditing(_ textField: UITextField) {
        // searchField.text = "" // （コメントアウト）テキストフィールドをクリア
    }
}

//MARK:- View update extension
extension WeatherViewController: WeatherManagerDelegate {
    
    func updateWeather(weatherModel: WeatherModel) {
        DispatchQueue.main.sync {
            // UIの更新はメインスレッドで行う必要があるため、メインキューで同期的に実行
            temperatureLabel.text = weatherModel.temperatureString // 温度ラベルを更新
            cityLabel.text = weatherModel.cityName // 都市名ラベルを更新
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName) // 天気状態の画像を更新
        }
    }
    
    func failedWithError(error: Error) {
        print(error) // エラーをデバッグ出力
    }
}

// MARK:- CLLocation
extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization() // アプリ使用中の位置情報の許可をリクエスト
        locationManager.requestLocation() // 現在の位置をリクエスト
    }
    
    // 位置情報が更新されたときに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude // 緯度を取得
            let lon = location.coordinate.longitude // 経度を取得
            weatherManager.fetchWeather(lat, lon) // 取得した緯度・経度で天気情報を取得
        }
    }
    
    // 位置情報の取得に失敗したときに呼ばれる
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error) // エラーをデバッグ出力
    }
}
