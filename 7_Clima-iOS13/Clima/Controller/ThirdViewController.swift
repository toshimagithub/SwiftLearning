//
//  ThirdViewController.swift
//  Clima
//
//  Created by 松原稔起 on 2024/08/27.
//  Copyright © 2024 App Brewery. All rights reserved.
//
import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // ナビゲーションバーのタイトルを設定
        self.title = "navTest"
        //UINavigationBarAppearanceクラスの新しいインスタンスを生成
        let appearance = UINavigationBarAppearance()
        //appearance.backgroundColor = UIColor.lightGray // 背景色を薄グレーに設定
        appearance.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        //オプショナルチェイニング navigationBar.scrollEdgeAppearanceにappearanceを格納
        //navigationBar.scrollEdgeAppearance: ナビゲーションバーのスクロール中やスクロールビューの端に達した時の外観を定義するプロパティ
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        // 左側に「戻る」ボタンを追加
        let backButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
    @objc func backButtonPressed() {
        // 現在の画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
}
