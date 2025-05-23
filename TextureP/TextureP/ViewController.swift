//
//  ViewController.swift
//  TextureP
//
//  Created by ykmason on 2025/5/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.present(ChatViewController(), animated: true)
    }
}

