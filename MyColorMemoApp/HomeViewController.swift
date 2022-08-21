//
//  HomeViewController.swift
//  MyColorMemoApp
//
//  Created by 小西琢斗 on 2022/08/21.
//

import Foundation
import UIKit //UIに関するクラスが格納されたモジュール

// HomeViewControllerにUIViewControllerを「クラス継承」する
// HomeViewController上でUIViewControllerの機能を使用することができる
class HomeViewController: UIViewController{
    // storyboardのコンポーネントと紐付けした際に表示される
    @IBOutlet weak var tableView: UITableView!
    
    var MemoDataList: [MemoDataModel] = []
    
    // LWCのconnectedCallback的なメソッド？
    // このクラスの画面が表示される際に呼び出されるメソッド
    // 画面の表示・非表示に応じて実行されるメソッドを「ライフサイクルメソッド」と呼ぶ
    override func viewDidLoad() {
        print("HomeViewControllerが表示されました！")
        tableView.dataSource = self
        //下記処理は以前はリスト数を指定しても指定した数以上が表示されていたための処理
        //フッターに空のviewを設定している
        //tableView.tableFooterView = UIView()
        
        setMemoData()
    }
    
    func setMemoData(){
        for i in 1...5{
            let memoDataModel = MemoDataModel(text: "このメモは\(i)番目のメモです。", recordDate: Date())
            MemoDataList.append(memoDataModel)
        }
    }
}

extension HomeViewController: UITableViewDataSource{
    //UITavleViewに表示するリストの数を指定するメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoDataList.count
    }
    
    //UITavleViewに表示するリストの中身を定義するメソッド
    //UITavleViewに表示される一つ一つをUITableCellまたはCall
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        // indexPath.row → UItableViewに表示されるCellの(0から始まる)通り番号が順番に渡される
        let memoDataModel: MemoDataModel = MemoDataList[indexPath.row]
        print(indexPath.row)
        print(indexPath)
        cell.textLabel?.text = memoDataModel.text
        cell.detailTextLabel?.text = "\(memoDataModel.recordDate)"
        return cell
    }
}
