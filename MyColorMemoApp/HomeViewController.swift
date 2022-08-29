//
//  HomeViewController.swift
//  MyColorMemoApp
//
//  Created by tkoishi on 2022/08/21.
//

import Foundation
import UIKit //UIに関するクラスが格納されたモジュール

//pod 'RealmSwift', '=10.1.4'

// HomeViewControllerにUIViewControllerを「クラス継承」する
// HomeViewController上でUIViewControllerの機能を使用することができる
// UIViewControllerとは？
class HomeViewController: UIViewController{
    // storyboardのコンポーネントと紐付けした際に表示される
    @IBOutlet weak var tableView: UITableView!
    
    //この処理はメモのcellを入れている？
    var MemoDataList: [MemoDataModel] = []
    
    // LWCのconnectedCallback的なメソッド？
    // このクラスの画面が表示される際に呼び出されるメソッド
    // 画面の表示・非表示に応じて実行されるメソッドを「ライフサイクルメソッド」と呼ぶ
    override func viewDidLoad() {
        print("HomeViewControllerが表示されました！")
        tableView.dataSource = self
        tableView.delegate = self
        //下記処理は以前はリスト数を指定しても指定した数以上が表示されていたための処理
        //フッターに空のviewを設定している
        //tableView.tableFooterView = UIView()
        
        setMemoData()
        
        setNavigationBarButton()
    }
    
    func setMemoData(){
        for i in 1...5{
            let memoDataModel = MemoDataModel()
            memoDataModel.text = "このメモは\(i)番目のメモです。"
            memoDataModel.recordDate = Date()
            MemoDataList.append(memoDataModel)
        }
    }
    
    //メモ詳細画面(MemoDetailViewController)を取得して遷移させる
    @objc func tapAddButton(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memoDetailViewController = storyboard.instantiateViewController(identifier: "MemoDetailViewController") as! MemoDetailViewController
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
    
    func setNavigationBarButton(){
        //ヘッダーに表示されたボタンをタップした際の処理を指定するためのクラス
        //ボタンをタップ後にtapAddButtonメソッドが呼ばれる
        //selectorクラスに指定するためのメソッドには、「@objc」をしてする必要がある
        let buttonActionSelector: Selector = #selector(tapAddButton)
        
        //UIBarButtonItem → UINavigation Controller に配置するボタンクラスのこと
        //barButtonSystemItem → ボタンの見た目を指定するもの
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: buttonActionSelector)
        
        
        //rightBarButtonItemに挿入することでヘッダーに表示される
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

//初期画面
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
        cell.textLabel?.text = memoDataModel.text
        cell.detailTextLabel?.text = "\(memoDataModel.recordDate)"
        return cell
    }
}

//詳細画面遷移
extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        let memoDetailViewController = storyboad.instantiateViewController(identifier: "MemoDetailViewController") as!
            MemoDetailViewController
        
        //詳細画面にデータを受け渡す処理
        let memoDate = MemoDataList[indexPath.row]
        //memoDetailViewControllerのconfigureメソッドを呼び出す
        memoDetailViewController.configure(memo: memoDate)
        
        //詳細画面に遷移後にホーム画面に戻った際に選択されてしまっている処理を無効化
        tableView.deselectRow(at: indexPath, animated: true)
        
        //ページ遷移
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
}
