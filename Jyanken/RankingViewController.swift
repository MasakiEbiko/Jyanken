//
//  RankingViewController.swift
//  Jyanken
//
//  Created by mba2408.spacegray kyoei.engine on 2024/11/06.
//

import UIKit
import RealmSwift

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let realm = try! Realm()
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var resultsArray = try! Realm().objects(Results.self).sorted(byKeyPath: "average", ascending: false)
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.fillerRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(viewRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }

    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Cellに値を設定する  --- ここから ---
        let result = resultsArray[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = String(result.average).prefix(4) + "%  (W:" + result.win + " L:" + result.lose + " D:" + result.draw + ")"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString:String = formatter.string(from: result.date)
        content.secondaryText = dateString
        cell.contentConfiguration = content
        // --- ここまで追加 ---
        return cell
    }

    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // --- ここから ---
        if editingStyle == .delete {
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.resultsArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } // --- ここまで追加 ---
    }
    
    @objc func viewRefresh(){
        print("bbbb")
        tableView.reloadData()
        // リフレッシュ表示動作停止
        if self.tableView.refreshControl!.isRefreshing {
            self.tableView.refreshControl!.endRefreshing()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
