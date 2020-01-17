//
//  ViewController2.swift
//  ClosureArcExp - Combine
//
//  Created by iamchiwon on 2018. 8. 13..
//  Modified by Joshua on 2020. 1. 17 ..
//  Copyright © 2018년 iamchiwon. All rights reserved.
//

import UIKit
import Combine

class LeakViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tapButton: UIButton!

    var count: Int = 0
    var cancelBag: Set<AnyCancellable> = Set()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ViewController2 - viewDidLoad (+1)")

        print("ViewController2 - do(onNext) (+1)")
        print("ViewController2 - subscribe(onNext) (+1)")
        tapButton.addTarget(self, action: #selector(onTouch(sender:)), for: .touchUpInside)

        let backButton = UIBarButtonItem(barButtonSystemItem: .rewind,
                                         target: self,
                                         action: #selector(onBack))
        navigationItem.setLeftBarButton(backButton, animated: true)

        //CancelBag에 넣었다 -> Leak 발생!
        _ = [1,2,3,4,5,6,7,8,9,10].publisher
            .delay(for: 0.5, scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { n in
                self.count = n
            }).map({"\($0)"})
            .sink(receiveValue: { s in
                self.countLabel.text = s
            }).store(in: &self.cancelBag)
    }

    @objc func onTouch(sender: UIButton) {
        self.count += 1
        self.countLabel.text = "\(self.count)"
    }

    @objc func onBack() {
        print("ViewController2 - onBack")
        // self.cancelBag.removeAll() // 주석 해제하면 정상적으로 해제됨
        navigationController?.popViewController(animated: true)
    }

    deinit {
        print("ViewController2 - deinit (-1)")
    }
}
