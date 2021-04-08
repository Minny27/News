//
//  NewsDetailController.swift
//  News
//
//  Created by SeungMin on 2021/04/08.
//

import UIKit

class NewsDetailController : UIViewController {
    
    @IBOutlet weak var ImageMain: UIImageView!
    @IBOutlet weak var LabelMain: UILabel!
    
    var imageUrl: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let img = imageUrl {
            // 이미지 보여주기
            // Data
            if let data = try? Data(contentsOf: URL(string: img)!) {
                // Main Thread
                DispatchQueue.main.async {
                    self.ImageMain.image = UIImage(data : data)
                }
            }
        }
        if let d = desc {
            self.LabelMain.text = d
        }
    }
    
        
    
}
