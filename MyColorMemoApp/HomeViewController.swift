//
//  HomeViewController.swift
//  MyColorMemoApp
//
//  Created by tkoishi on 2022/08/21.
//

import Foundation
import UIKit //UIに関するクラスが格納されたモジュール
import RealmSwift

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
    //viewDidLoad はメモリが割り当てられた一回のみ呼ばれるメソッド
    override func viewDidLoad() {
        print("HomeViewControllerが表示されました！")
        tableView.dataSource = self
        tableView.delegate = self
        //下記処理は以前はリスト数を指定しても指定した数以上が表示されていたための処理
        //フッターに空のviewを設定している
        //tableView.tableFooterView = UIView()
        
        
        
        setNavigationBarButton()
        setLeftNavigationBarButton()
    }
    
    //画面の表示が行われるたびにデータの取得が行われる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMemoData()
        //データを画面に表示させるために、画面の更新を行う処理
        tableView.reloadData()
    }
    
    func setMemoData(){
//        for i in 1...5{
//            let memoDataModel = MemoDataModel()
//            memoDataModel.text = "このメモは\(i)番目のメモです。"
//            memoDataModel.recordDate = Date()
//            MemoDataList.append(memoDataModel)
//        }
        let realm = try! Realm()
        //MemoDataModelのデータを全件取得
        let result = realm.objects(MemoDataModel.self)
        //配列に代入
        MemoDataList = Array(result)
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
    func setLeftNavigationBarButton(){
        let buttonActionSelector: Selector = #selector(didTapColorSettingButton)
        //画像をインスタンス化
        let leftButtonImage = UIImage(named: "colorSettingIcon")
        let leftButton = UIBarButtonItem(image: leftButtonImage, style: .plain, target: self, action: buttonActionSelector)
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func didTapColorSettingButton(){
        //UIAlertAction アラートをタップした際の処理内容タイトル、処理内容などを引数で渡すことができる
        let defaultAction = UIAlertAction(title: "デフォルト", style: .default, handler:{ _ -> Void in
            self.setThemeColor(type: .default)
        })
        let orangeAction = UIAlertAction(title: "オレンジ", style: .default, handler: {_ -> Void in
            self.setThemeColor(type: .orange)
        })
        let redAction = UIAlertAction(title: "レッド", style: .default, handler: {_ -> Void in
            self.setThemeColor(type: .red)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "テーマカラーを選択してください", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(defaultAction)
        alert.addAction(orangeAction)
        alert.addAction(redAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func setThemeColor(type: MyColorType){
        print(type.color)
        navigationController?.navigationBar.barTintColor = type.color
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){

        let targetMemo = MemoDataList[indexPath.row]
        let realm = try! Realm()
        try! realm.write{
            realm.delete(targetMemo)
        }
        MemoDataList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
