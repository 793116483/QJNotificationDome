//
//  AppDelegate.swift
//  本地通知Dome
//
//  Created by 瞿杰 on 2019/11/24.
//  Copyright © 2019 yiniu. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// 请求授权
    func registerAuthor() {
        
        if #available(iOS 8.0, *) {
            // 1. 注册通知类型
            let types = UIUserNotificationType.alert.rawValue | UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue
            
            // 2. 添加一组行为
            let category = UIMutableUserNotificationCategory()
            category.identifier = "标识"
            
            // 2.1
            let action1 = UIMutableUserNotificationAction()
            // 行为按钮文字
            action1.title = "确定"
            // 在点击了 确定后，再出现一个textField文本框
            if #available(iOS 9.0, *) {
                action1.behavior = .textInput
                // 文本框
                action1.parameters = [UIUserNotificationTextInputActionButtonTitleKey:"发送按钮title"]
            }
            // 模式: 就是点击了这个动作，是回到前台执行这个动作，还是直接在后台执行这个动作
            action1.activationMode = .foreground
            // true:必须解锁后,行为才会被执行,(如果 activationMode = .foreground , 那么这个属性被忽略)
            action1.isAuthenticationRequired = true
            // 是否是破坏性行为
            action1.isDestructive = true
            
            let action2 = UIMutableUserNotificationAction()
            action2.behavior = .textInput
            action2.title = "行为2提示title"
            // 模式: 就是点击了这个动作，是回到前台执行这个动作，还是直接在后台执行这个动作
            action2.activationMode = .background
            action2.isAuthenticationRequired = false
            action2.isDestructive = false
            
            // default : 最多可以显示 4 个按钮
            // minimal : 最多可以显示 2 个按钮
            let actionContext:UIUserNotificationActionContext = .default
            
            // 2.2 添加一组行为
            category.setActions([action1 , action2], for: actionContext)
            
            // 2.3 附加操作行为
            let categories:Set<UIUserNotificationCategory>? = NSMutableSet(object: category) as! Set<UIUserNotificationCategory>
            
            // 3. 通知配制
            let settings = UIUserNotificationSettings(types:UIUserNotificationType(rawValue: types) , categories: categories)
            
            // 4. 注册通知
            UIApplication.shared.registerUserNotificationSettings(settings)
            
        }
        else {
            let type = UIRemoteNotificationType(rawValue: UIRemoteNotificationType.alert.rawValue |  UIRemoteNotificationType.badge.rawValue | UIRemoteNotificationType.sound.rawValue)
            UIApplication.shared.registerForRemoteNotifications(matching: type)
        }
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerAuthor()
        
        // 应用进程被 kill 了，用户点击了通知启动app的
        applicationDidFinishLaunchingLocalNotification(launchOptions: launchOptions)
        
        return true
    }

   

}

// 本地通知
extension AppDelegate {
//    // 点击了 本地通知行为 回调
//    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
//
//        print(identifier , notification)
//
//        completionHandler()
//    }
    // 如果实现了这个方法，上面的方法就不会被执行
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        
        print(identifier , notification , responseInfo)
        
        completionHandler()
    }
    
    // 接收到通知
    // 在前台时收到通知，可以打印
    // app在后台接收到通知，如果app进入前台，立即打印
    // 如果退出app收到的通知，重新打开app不会打印
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if application.applicationState == .active { // 应用在前台时收到通知
            print("应用在前台时，接收到本地通知")

        } else if application.applicationState == .inactive { // 应用在后台收到通知，然后点击通知进入前台，来到该方法
            print("用应在后台，用户点击了本地通知，接收到本地通知")
        }
    }

    // 当app被关闭时，用户收到通知，然后点击通知，重新启动app
    func applicationDidFinishLaunchingLocalNotification(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        if let localNotif = launchOptions?[UIApplication.LaunchOptionsKey.localNotification]  as? UILocalNotification{
            print("应用进程被 kill 了，用户点击了通知启动app的，接收到本地通知")
            
            // 显示 通知内容
            let tv = UITextView(frame: CGRect(x: 0, y: 100, width: 300, height: 300))
            tv.backgroundColor = .blue
            tv.text = localNotif.description
            window?.rootViewController?.view.addSubview(tv)
        }
    }
}

// 远程推通知
// 前提：需要有安装 远程推送通知证书
extension AppDelegate {
    // 远程注册成功后，从苹果服务器获取到 deviceToken(uuid+bundleID标识设备的app) 传给自己的服务器保存起来
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
    }
    // 收到远程通知
    // 在前台收到 远程通知
    // 从后台进入前台收到 远程通知
    // 当app被关闭，收到远程推送通知，点击了该通知，重新调起 app 收到 远程通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        
        // 回调系统代码块作用:
        // 1> 系统会估量App消耗的电量，并根据传递的 UIBackgroundFetchResult 参数记录新数据是否可用
        // 2> 调用 completionHandler 代码块时，应用的界面缩略图会自动更新
        completionHandler(UIBackgroundFetchResult.newData)
    }
}


// 极光推送：https://www.jiguang.cn/push
// 开发流程按照开发指南做就好
// 发送一个测试通知，可以在网站上发送

