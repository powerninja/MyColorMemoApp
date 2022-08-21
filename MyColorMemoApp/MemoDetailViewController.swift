//
//  MemoDetailViewController.swift
//  MyColorMemoApp
//
//  Created by tkonishi on 2022/08/21.
//

import UIKit

class MemoDetailViewController: UIViewController{
    @IBOutlet weak var textView: UITextView!
    
    var text: String = ""
    var recordDate: Date = Date()
    
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
    }
    
    func configure(memo: MemoDataModel){
        text = memo.text
        recordDate = memo.recordDate
        print("データは\(text)と\(recordDate)です")
    }
    
    func displayData(){
        textView.text = text
        //下記では日付取得できず
        //var formatDate = dateFormat()
        navigationItem.title = dateFormat.string(from: recordDate)
    }
}
