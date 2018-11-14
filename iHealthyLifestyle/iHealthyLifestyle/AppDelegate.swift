//
//  AppDelegate.swift
//  iHealthyLifestyle
//
//  Created by ISSD on 10/04/2018.
//  Copyright © 2018 ISSD. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var centerContainer: MMDrawerController?
    var viewControler = SingleWorkoutViewController()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        
        if(Auth.auth().currentUser != nil){
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let centerViewController = mainStoryboard.instantiateViewController(withIdentifier: "ExercisesViewController") as! ExercisesViewController
            
            let leftViewController = mainStoryboard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
            
            let leftSideNav = UINavigationController(rootViewController: leftViewController)
            let centerNav = UINavigationController(rootViewController: centerViewController)
            
            centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: leftSideNav)
            
            centerContainer?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
            centerContainer?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
            
            window!.rootViewController = centerContainer
            window!.makeKey()
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert ]) { (authorized:Bool, error:Error? ) in
            if !authorized{
                print("You have declined to use our notification function!")
            }
            
            let badAction = UNNotificationAction(identifier: "bad", title: "You are feeling bad", options: [])
            let goodAction = UNNotificationAction(identifier: "good", title: "You are feeling good", options: [])
            let normalAction = UNNotificationAction(identifier: "normal", title: "You are feeling witout any change", options: [])
            
            let category = UNNotificationCategory(identifier: "feeling category", actions: [goodAction, badAction, normalAction], intentIdentifiers: [], options: [])
            
            UNUserNotificationCenter.current().setNotificationCategories([category])
        }
        
        return true
    }
    
    func scheduleNotification() {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let content = UNMutableNotificationContent()
        
        content.title = "Tell us how you feel"
        content.body = "Reminding you to give us feedback on how you feel after the workout"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "feeling category"
        
        guard let path = Bundle.main.path(forResource: "emotion", ofType: "jpeg")else { return}
        let url = URL(fileURLWithPath: path)
        do {
            let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
            content.attachments = [attachment]
        }catch{
            print("failed to load attachment")
        }
        
        let request = UNNotificationRequest(identifier: "Feeling notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "bad"{
            viewControler.userAnswer.append(0)
        }
        if response.actionIdentifier == "normal"{
            viewControler.userAnswer.append(1)
        }
        if response.actionIdentifier == "good"{
            viewControler.userAnswer.append(2)
        }
        
        completionHandler()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

}

