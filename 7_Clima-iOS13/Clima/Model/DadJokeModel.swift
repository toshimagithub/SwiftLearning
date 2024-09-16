//
//  DadJokeModel.swift
//  Clima
//
//  Created by 松原稔起 on 2024/09/16.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

// DadJokeModel は実際のアプリ内で表示するための構造体です。
// ここではシンプルな構造体として定義していますが、必要に応じてプロパティやメソッドを追加できます。
struct DadJokeModel {
    let jokeText: String
    
    // このプロパティは、UI で表示する際に必要なフォーマットを提供できます。
    var formattedJoke: String {
        return "Here's a dad joke for you: \(jokeText)"
    }
}

