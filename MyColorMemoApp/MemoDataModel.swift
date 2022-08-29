//
//  MemoDataModel.swift
//  MyColorMemoApp
//
//  Created by 小西琢斗 on 2022/08/21.
//

import Foundation
import RealmSwift


// classの場合、初期値の指定が必要
// sturactの場合、初期値は不要
class MemoDataModel: Object{
    //UUID().uuidStringアクセスのたびに一意のidを付与してくれる
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var text: String = ""
    @objc dynamic var recordDate: Date = Date()
}
