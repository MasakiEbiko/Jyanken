//
//  Results.swift
//  Jyanken
//
//  Created by mba2408.spacegray kyoei.engine on 2024/11/06.
//

import RealmSwift

class Results: Object {
    // 管理用 ID。プライマリーキー
    @Persisted(primaryKey: true) var id: ObjectId
    // 勝ち数
    @Persisted var win = ""
    // 負け数
    @Persisted var lose = ""
    // 引き分け
    @Persisted var draw = ""
    // 勝率
    @Persisted var average = 0.0
    // 保存日時
    @Persisted var date = Date()
}
