//
//  HomeViewController.swift
//  Jyanken
//
//  Created by mba2408.spacegray kyoei.engine on 2024/11/06.
//

import UIKit
import RealmSwift
import SVProgressHUD

class HomeViewController: UIViewController {
    
    var timer: Timer!
    var n: UInt32!
    var resultHistory:[Int]! = [0,0,0]
    var roundAvg:Float = 0.0
    let realm = try! Realm()
    var results: Results!
    
    let appDelegate:AppDelegate  = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var gooButton: UIButton!
    @IBOutlet weak var chokiButton: UIButton!
    @IBOutlet weak var perButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gooButton.isEnabled = false
        chokiButton.isEnabled = false
        perButton.isEnabled = false
        historyLabel.text = ""
        saveButton.isHidden = true
        startButton.setTitle("Start", for: .normal)
    }

    @IBAction func start(_ sender: Any) {
        if self.startButton.currentTitle == "Start" {
            // Start時処理
            // タイマーを設定
            timer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(updateJanken),
                userInfo: nil,
                repeats: true
            )
            gooButton.isEnabled = true
            chokiButton.isEnabled = true
            perButton.isEnabled = true
            resultLabel.text = ""
            startButton.setTitle("Reset", for: .normal)
        } else {
            // タイマー停止
            if timer != nil {
                timer.invalidate()
            }
            imageView.image = nil
            gooButton.isEnabled = false
            chokiButton.isEnabled = false
            perButton.isEnabled = false
            saveButton.isHidden = true
            resultLabel.text = "Press Start Button!"
            historyLabel.text = ""
            startButton.setTitle("Start", for: .normal)
        }
    }
    
    // 結果判定
    func janken_check(_ data: UInt32){
        // 画像を再表示
        updateJanken()
        
        var res = 0
        
        if(n == data){
            // 引き分け
            res = 0
        }else{
            switch(data){
            case 1:
                if(n == 2){
                    res = 1
                }else{
                    res = -1
                }
                break
                
            case 2:
                if(n == 3){
                    res = 1
                }else{
                    res = -1
                }
                break

            default:
                if(n == 1){
                    res = 1
                }else{
                    res = -1
                }
                break
            }
        }
        
        // 結果表示
        var str = ""
        switch(res){
        case 1:
            str = "You Win！!"
            resultHistory[0] += 1
            break
        case -1:
            str = "You Lose！!"
            resultHistory[1] += 1
            break
        default:
            str = "Draw."
            resultHistory[2] += 1
            break
        }
        
        self.resultLabel.text = str
        let avg = (Float(resultHistory[0]) / Float(resultHistory[0] + resultHistory[1] + resultHistory[2])) * 100
        roundAvg = round(avg*10)/10
        
        self.historyLabel.text = "W:"+String(resultHistory[0])+" L:"+String(resultHistory[1])+" D:"+String(resultHistory[2]) + " Avg:" + String(roundAvg) + "%"

        if historyLabel.text != "" { saveButton.isHidden = false}

        // タイマー停止
        if timer != nil { timer.invalidate() }
        
    }
    
    @IBAction func goo(_ sender: Any) {
        self.janken_check(1)
    }
    @IBAction func choki(_ sender: Any) {
        self.janken_check(2)
    }
    @IBAction func per(_ sender: Any) {
        self.janken_check(3)
    }
    
    func changeImage()->String{
        var file:String = ""
        n = arc4random() % 3 + 1;
        switch(n){
        case 1:
            file = "janken_gu.png"
            break;
        case 2:
            file = "janken_choki.png"
            break;
        default:
            file = "janken_pa.png"
            break;
        }
        return file
    }
    
    // ランダムに画像を表示
    @objc func updateJanken(){
        let file: String = changeImage()
        print(file)
        // 画像の設定
        let myImage = UIImage(named: file)
        // 画像をUIImageViewに設定
        imageView.image = myImage
    }
    
    //結果をRealmに保存
    @IBAction func saveResults(_ sender: Any) {
        let results = Results()
        try! realm.write {
            results.win = String(resultHistory[0])
            results.lose = String(resultHistory[1])
            results.draw = String(resultHistory[2])
            results.average = Double(roundAvg)
            self.realm.add(results, update: .modified)
        }
        // HUDで保存完了を表示する
        SVProgressHUD.showSuccess(withStatus: "Save Completed.")
        //
        appDelegate.rankingViewRefresh()
    }
}
