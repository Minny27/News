//
//  ViewController.swift
//  News
//
//  Created by SeungMin on 2021/04/07.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var TableViewMain: UITableView!
    
    var newsdata : Array<Dictionary<String, Any>>?
    
    // News Api에서의 Json data 가져오기
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string: "https://newsapi.org/v2/top-headlines?country=kr&category=business&apiKey=712563d999c042a2a8ed4f9e47536561")!) { (data, respones, error) in
            // Json Parsing
            if let dataJson = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    print(articles)
                    self.newsdata = articles
                    DispatchQueue.main.async {
                        self.TableViewMain.reloadData() // Main
                    }
                }
                catch{}
            }
            
        }
        task.resume()
    }
    
    // 테이블의 행을 몇 개 만들 것인가
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = newsdata {
            return news.count
        }
        else {
            return 0
        }
    }
    
    // 행 안에 무엇을 입력할 것인가
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "TableCellType1")
        // as? as! -> 자식의 친자 확인
        // 이 코드가 자주쓰는 방법
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
//        cell.textLabel?.text = "\(indexPath.row)"
        let idx = indexPath.row
        if let news = newsdata {
            let row = news[idx]
            if let r = row as? Dictionary<String, Any> {
                if let title = r["title"] as? String {
                    cell.LabelText.text = title
                }
            }
        }
        return cell
    }
    
    // 클릭 감지
    // 데이터 이동 -> 수동
    func tableview(tableview: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Click !!! \(indexPath.row)")
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NewsDetailController") as! NewsDetailController
        if let news = newsdata {
            let row  = news[indexPath.row]
            print("row :: \(row)")
            if let r = row as? Dictionary<String, Any> {
                if let imageUrl = r["urlToImage"] as? String {
                    controller.imageUrl =  imageUrl
                }
                if let desc = r["description"] as? String {
                    controller.desc = desc
                }
            }
        }
//        showDetailViewController(controller, sender: nil)
    }
    
    
    // 세크 웨이 : 부모 - 자식
    // 데이터 이동 -> 자동
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "NewsDetail" == id {
            if let controller = segue.destination as? NewsDetailController {
                
                if let news = newsdata {
                    if let indexPath = TableViewMain.indexPathForSelectedRow {
                        let row  = news[indexPath.row]
                        print("row :: \(row)")
                        if let r = row as? Dictionary<String, Any> {
                            if let imageUrl = r["urlToImage"] as? String {
                                controller.imageUrl =  imageUrl
                            }
                            if let desc = r["description"] as? String {
                                controller.desc = desc
                            }
                        }
                    }
                }
            }
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // self는 현재 클래스를 의미한다. -> 현재 클래스의 함수에 접근
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        getNews()
    }


}

