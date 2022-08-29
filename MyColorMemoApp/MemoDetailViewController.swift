//
//  MemoDetailViewController.swift
//  MyColorMemoApp
//
//  Created by tkonishi on 2022/08/21.
//

import UIKit
import RealmSwift

class MemoDetailViewController: UIViewController{
    @IBOutlet weak var textView: UITextView!
    
    var memoData = MemoDataModel()
    
    //表示する日付のフォーマットを修正
    var dateFormat: DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter
    }
    
    //画面表示された際に呼び出されるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
        setDoneButton()
        textView.delegate = self
    }
    
    func configure(memo: MemoDataModel){
        memoData.text = memo.text
        memoData.recordDate = memo.recordDate
        //print("データは\(text)と\(recordDate)です")
    }
    
    func displayData(){
        textView.text = memoData.text
        //下記では日付取得できず
        //var formatDate = dateFormat()
        navigationItem.title = dateFormat.string(from: memoData.recordDate)
    }
    
    //view.endEditing(true) → 現在表示されているキーボードを閉じる
    @objc func tapDoneButton(){
        view.endEditing(true)
    }
    
    //キーボードに閉じるボタンを追加するメソッド
    func setDoneButton(){
        //キーボード上部にボタンを追加するための処理
        //コードを使ってUIを生成するため、幅や高さを指定しインスタンス化している
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        
        //キーボードを閉じるためのボタンを作成
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        
        //toolbarに表示するボタンを入れる
        //キーボード上部のボタンには複数ボタン配置が可能なため、配列にしボタンを入れる
        toolBar.items = [commitButton]
        
        //UIにボタンを追加する
        textView.inputAccessoryView = toolBar
    }
    
    func saveDate(with text: String){
        // デフォルトRealmを取得します
        let realm = try! Realm()
        try! realm.write{
            memoData.text = text
            memoData.recordDate = Date()
            realm.add(memoData)
        }
        print("text: \(memoData.text), recordDate: \(memoData.recordDate)")
    }
}


extension MemoDetailViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let updatedText = textView.text ?? ""
        saveDate(with: updatedText)
    }
}
