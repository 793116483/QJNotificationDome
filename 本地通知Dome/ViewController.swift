//
//  ViewController.swift
//  本地通知Dome
//
//  Created by 瞿杰 on 2019/11/24.
//  Copyright © 2019 yiniu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func pushNotifaction(_ sender: Any) {
        // 创建本地通知
        let localNotif = UILocalNotification()
        
        // 显示 title 标题
        localNotif.alertTitle = "我的应用"
        
        // 设置通知的必选项
        localNotif.alertBody = "他来了他来了，准备！！！！"
        // 发送时间
        localNotif.fireDate = NSDate(timeIntervalSinceNow: 2) as Date
        
        // 重复周期
//        localNotif.repeatInterval = .second
        // 设置锁屏滑动文字
        localNotif.hasAction = true
        localNotif.alertAction = "回复"
        
        // ios 9.0前有效，之后无效
        localNotif.alertLaunchImage = ""
        
        // 通知声音
        localNotif.soundName = "自己导入的声音文件全名"
        
        // 应用角标
        localNotif.applicationIconBadgeNumber = 10
        
        // 其他信息
        localNotif.userInfo = ["ds":"dswr323"]
        
        UIApplication.shared.scheduleLocalNotification(localNotif)
    }
    
    @IBAction func cancelNotification(_ sender: Any) {
        
        // 取消所有的
        UIApplication.shared.cancelAllLocalNotifications()
    }
    @IBAction func lookNotification(_ sender: Any) {
        // 查看准备发送的本地通知
        print(UIApplication.shared.scheduledLocalNotifications)
    }
    
    
}

