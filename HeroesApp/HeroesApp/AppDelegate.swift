//
//  AppDelegate.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 27/02/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (success, error) in
            if error != nil {
                print ("authorization fails")
            }
            else{
                print ("authorization succesful")
            }
            
        }
        UNUserNotificationCenter.current().delegate = self
        self.recoverTabIndex()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.saveTabIndex()

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()

    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "heroe")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    //MARK: save tab index funtions
    func saveTabIndex(){
        let tabViewController = self.window!.rootViewController as! UITabBarController
        let indexToSave = tabViewController.selectedIndex
        UserDefaults.standard.set(indexToSave, forKey: "tabIndex")

    }
    func recoverTabIndex(){
        let index = UserDefaults.standard.integer(forKey: "tabIndex")
        let tabViewController = self.window!.rootViewController as! UITabBarController
        tabViewController.selectedIndex = index
        
    }

}
// MARK: notifications functions
extension AppDelegate: UNUserNotificationCenterDelegate{
    /*
     When the notification is presented
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
    /*
     When the notification HeroeDetails is pressed then navigate to hero details
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "HeroeDetails"{
            let notiInfo = response.notification.request.content.userInfo
            //print("original identifier was : \(response.notification.request.identifier)")
            // in userInfo commming the heroe as raw encode data with hero codable type
            let data = notiInfo["heroe"] as! Data
            let heroe = try? JSONDecoder().decode(Heroe.self, from: data)
            let tabViewController = self.window!.rootViewController as! UITabBarController
            let rootViewController = tabViewController.viewControllers?[0] as? UINavigationController //characters tab
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let detailController = mainStoryboard.instantiateViewController(withIdentifier: "DetalleViewController") as! DetalleViewController
            detailController.miHeroe = heroe
            rootViewController?.pushViewController(detailController, animated: true)
            tabViewController.selectedIndex = 0 //necessary to change tabnavigation
            completionHandler()
        }
        
    }
}

