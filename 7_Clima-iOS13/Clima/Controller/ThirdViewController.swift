//
//  ThirdViewController.swift
//  Clima
//
//  Created by 松原稔起 on 2024/08/27.
//  Copyright © 2024 App Brewery. All rights reserved.
//
import UIKit
import Foundation

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // ナビゲーションバーのタイトルを設定
        self.title = "navTest"
        // ナビゲーションバーの背景色を薄グレーに設定
        // ナビゲーションバーの外観をカスタマイズ
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 不透明な背景を設定
        //appearance.backgroundColor = UIColor.lightGray // 背景色を薄グレーに設定？
        appearance.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        print("クリック")
        // カスタム外観を適用
        navigationController?.navigationBar.standardAppearance = appearance
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
