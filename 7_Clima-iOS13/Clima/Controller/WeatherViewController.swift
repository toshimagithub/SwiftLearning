//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit //UIViewControllerを使うためにimportしてる
import CoreLocation //位置情報を取得するフレームワーク

//UIViewControllerを継承したWeatherViewControllerというクラス
//基本的にUIViewControllerは継承して使う、iOS のフレームワークの一部であり、UIKit フレームワークに含まれる
class WeatherViewController: UIViewController {
    //IBがInterface Builderの略
    @IBOutlet weak var conditionImageView: UIImageView!   // 表示画面に天気アイコン（画像）を表示するため
    @IBOutlet weak var temperatureLabel: UILabel! // 表示画面に温度を表示するため
    @IBOutlet weak var cityLabel: UILabel!        // 表示画面に都市名を表示するため
    @IBOutlet weak var searchField: UITextField!   // ユーザーが都市名を入力するためのテキストフィールド
    @IBOutlet weak var background: UIImageView! //　これでViewのbackgroundという画像の部分と繋がる
    @IBOutlet weak var favoriteButton: UIButton!    //MARK: Properties
    //型推論を使用して変数にインスタンスを代入
    var weatherManager = WeatherDataManager() //インスタンスを作成し、天気データの取得や管理を行います
    let locationManager = CLLocationManager() //インスタンスを作成し、ユーザーの現在位置を取得・管理 import CoreLocationしているからCLLocationManager()が使える
    
    //UIViewController クラスの viewDidLoad メソッドをオーバーライドしている
    override func viewDidLoad() {
        super.viewDidLoad()//UIKitのviewDidLoad()メソッドの機能を呼び出し
        
        locationManager.delegate = self // CLLocationManagerが位置情報のイベントをWeatherViewControllerに通知するよう設定する
        weatherManager.delegate = self // WeatherDataManagerが天気データの更新イベントをWeatherViewControllerに通知するよう設定する
        searchField.delegate = self // UITextFieldの編集イベントをWeatherViewControllerに通知するよう設定する
        let heartImage = UIImage(systemName: "suit.heart.fill")
        favoriteButton.setImage(heartImage, for: .normal)
        favoriteButton.setTitle("", for: .normal)
        favoriteButton.frame.size = CGSize(width: 80, height: 80)
        // ボタンにアクションを追加
               favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
           }

           @objc func favoriteButtonPressed() {
               // ThirdViewControllerのインスタンスを作成
               let thirdViewController = ThirdViewController(nibName: "ThirdView", bundle: nil)
               
               // UINavigationControllerにThirdViewControllerをラップ
               let navigationController = UINavigationController(rootViewController: thirdViewController)
               
               // 画面遷移を行う
               navigationController.modalPresentationStyle = .fullScreen
               present(navigationController, animated: true, completion: nil)
           }
       }
//MARK:- TextField extension
//WeatherViewControllerがUITextFieldDelegate準拠し、WeatherViewControllerを拡張する
extension WeatherViewController: UITextFieldDelegate {
        //メソッドや関数の前には、funcが必要
        //@IBAction は、UI要素のアクションとメソッドを接続するために使用されます。
    // 引数 'sender' は、アクションをトリガーした UIButton のインスタンスを指します
        @IBAction func searchBtnClicked(_ sender: UIButton) {
            searchField.endEditing(true)    //dismiss keyboard     // キーボードを閉じるために、searchField（テキストフィールド）の編集を終了する
            print(searchField.text!)     // テキストフィールドの内容をコンソールに出力する
            searchWeather()
        }
        func searchWeather(){
            //searchField.textがnilでない場合、trueになる
            if let cityName = searchField.text{
                //var weatherManager = WeatherDataManager()
                //fetchWeather(cityName) は WeatherDataManager クラスのメソッドであり、cityName という引数を受け取って天気データを取得する機能を持っている
                weatherManager.fetchWeather(cityName)
            }
        }
        // when keyboard return clicked
    //textFieldShouldReturn メソッドは、
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchField.endEditing(true)    //dismiss keyboard
            print(searchField.text!)
            searchWeather()
            return true
        }
        // when textfield deselected
        //textFieldShouldEndEditingはUITextFieldDelegate プロトコルに定義されてる
        //このメソッドはテキストフィールドがリターンキー（Enterキー）を押されたときに呼び出される
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            // by using "textField" (not "searchField") this applied to any textField in this Controller(cuz of delegate = self)
            //textFieldが空でない場合"true"を返す
            if textField.text != "" {
                return true
            }else{
            //text.Fieldが空の場合、textFieldに"Type something here"が表示
                textField.placeholder = "Type something here"
                //return false で、編集が終了しないようにしている
                return false            // check if city name is valid
            }
        }
        // when textfield stop editing (keyboard dismissed)
        //textFieldDidEndEditing(_:) メソッドは UITextFieldDelegate プロトコルに定義されてる
        //このメソッドは、テキストフィールドが編集を終了したとき（ユーザーがキーボードを閉じる、または他の場所をタップするなど）に呼び出されます。　実行内容がコメントアウトしてるから何も実行してない
        func textFieldDidEndEditing(_ textField: UITextField) {
    //        searchField.text = ""   // clear textField
        }
}
//MARK:- View update extension
// WeatherManagerDelegateは何もimportしなくても使える
//WeatherManagerDelegateを準拠し拡張したWeatherViewControllerクラス
//weatherManager.delegate = self によって、WeatherManager のデリゲートとして WeatherViewController を設定してる
extension WeatherViewController: WeatherManagerDelegate {
    
    func updateWeather(weatherModel: WeatherModel){
        DispatchQueue.main.sync {
            temperatureLabel.text = weatherModel.temperatureString
            cityLabel.text = weatherModel.cityName
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
            if searchField.text == "Tokyo" {
                background.image  = UIImage(named: "dark_background")
            } else {
                background.image  = UIImage(named: "light_background")
            }
            if let temperature = Double(weatherModel.temperatureString), temperature >= 30 {
                background.image = UIImage(named: "dark_background")
            }
        }
        if let cityName = searchField.text {
            print("action: search, city: \(cityName)")
        }
    }
    func failedWithError(error: Error){
        print(error)
    }
}

// MARK:- CLLocation
//import CoreLocationがあるからCLLocationManagerDelegateが使えている。
//CLLocationManagerDelegateを準拠し拡張したWeatherViewController
extension WeatherViewController: CLLocationManagerDelegate {
    // このメソッドは、ユーザーが「位置情報取得」ボタンをクリックしたときに呼び出されます。
    // ボタンがクリックされると、位置情報の取得に関連する処理が実行されます。
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        // Get permission
        // ユーザーに位置情報の使用許可を求める
        // アプリがフォアグラウンドに表示されているときに位置情報を利用するための権限をリクエストします。
        locationManager.requestWhenInUseAuthorization()
        // 現在の位置情報を取得するリクエストを送信します
        // このメソッドを呼び出すことで、アプリが位置情報の取得を開始します。
        // 成功すると、位置情報が `CLLocationManagerDelegate` のメソッドを通じて渡されます。
        locationManager.requestLocation()
    }
    //CLLocationManagerDelegate プロトコルに定義されているlocationManagerメソッドをオーバーライドして実装
    //CLLocationManagerとlocationsが引数
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locations.lastがnilでなければ実行される
        if let location = locations.last {
        //location オブジェクトの coordinate プロパティから、緯度（latitude）を取り出し、lat という定数に代入します。
            let lat = location.coordinate.latitude
        //location オブジェクトの coordinate プロパティから、経度（longitude）を取り出しlon という定数に代入します。
            let lon = location.coordinate.longitude
        //緯度（lat）と経度（lon）を引数として渡し指定した位置情報を使って天気データを取得する
            weatherManager.fetchWeather(lat, lon)
        }
    }
    //CLLocationManagerDelegate プロトコルに定義されているlocationManagerメソッドをオーバーライドして実装
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
