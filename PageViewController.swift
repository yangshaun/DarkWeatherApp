//
//  PageViewController.swift
//  
//
//  Created by Shaun Yang on 11/20/19.
//

import UIKit
import SwiftyJSON
import SwiftSpinner

class PageViewController: UIPageViewController,UIPageViewControllerDataSource,UISearchBarDelegate {
    
    
    var pagelist = [UIViewController]()
    var homeVC: ViewController?
//    var Master: MasterViewController?
    var isnotRenew:Bool!
    override func viewDidLoad() {
        self.demoSpinner()
        super.viewDidLoad()
        
        setupHomepage()
        dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
////        setNaviBarSearch()
//        print(self.isnotRenew,Master?.IsItHomePage)
//        if self.isnotRenew == true || Master?.IsItHomePage == true {
//
//        }else{
        
        let decoded  = UserDefaults.standard.object(forKey:"HomeDict") as! Data
        let decoded_Dict = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Dictionary<String,UIViewController>
        
        if decoded_Dict.count + 1 == self.pagelist.count{
            
        }else{
            
            renewPage()
        }
        
        
        
        
        
        
//        }
    }
    
    func renewPage(){
        self.homeVC  = (storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
        self.homeVC?.isSearchByText = false
        self.homeVC?.myPageViewController = self
        var new  = [UIViewController]()
        new.append(self.homeVC!)
        
        
        let decoded  = UserDefaults.standard.object(forKey:"HomeDict") as! Data
        let decoded_Dict = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Dictionary<String,UIViewController>
        for (key,_) in decoded_Dict{
            let tmp = (storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
            tmp.isSearchByText = true
            tmp.SearchText = key
            tmp.myPageViewController = self
            new.append(tmp)
        }
        pagelist = new
        self.setViewControllers([(pagelist[0])], direction: .forward, animated: false, completion: nil)
        
    }
    func showMSG(_ text:String){
        
        self.view.makeToast(text)
        
    }
   
    
    
    func setupHomepage(){
        self.homeVC = (storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
        self.homeVC?.isSearchByText = false
        self.homeVC?.myPageViewController = self
        pagelist = [homeVC!]
        
        if isKeyPresentInUserDefaults(key: "HomeDict") {
            
            
            let decoded  = UserDefaults.standard.object(forKey:"HomeDict") as! Data
            let decoded_Dict = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Dictionary<String,UIViewController>
            
            for (key,_) in decoded_Dict{
                let tmp = (storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
                print (key,"!!!!!!!!!?????")
                tmp.isSearchByText = true
                tmp.SearchText = key
                tmp.myPageViewController = self
                pagelist.append(tmp)
            }
        }else{
            let emptyDictionary = [String: UIViewController]()
            
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: emptyDictionary)
            
            UserDefaults.standard.set(encodedData, forKey:"HomeDict")
        }
        
        
        setViewControllers([pagelist[0]], direction: .forward, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pagelist.firstIndex(of:viewController), index > 0 {
            return pagelist[index - 1]
        }
        return nil
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = pagelist.firstIndex(of:viewController), index < pagelist.count - 1 {
            return pagelist[index+1]
        }
        return nil
        
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pagelist.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
//        return 0
    }
    
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for v in view.subviews{
            if v is UIScrollView{
                v.frame = view.bounds
                break
            }
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//
//        print ("qwertyuioplkjhgfdsazxcvbnm")
//
//        if let barVC2 = segue.destination as? ViewController {
//            barVC2.myPageViewController = self
//            print(" View Did Appear")
//        }
//
//
//        
//
//    }
    
    
//    ==============================
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SwiftSpinner.show("")
        return true
    }
    func delay(seconds: Double, completion: @escaping () -> ()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    func demoSpinner() {
        UIView.animate(withDuration:1) {
            self.view.transform = .identity
        }
        SwiftSpinner.show(delay: 0.0, title: "Loading...", animated: true)
        
        self.delay(seconds: 2.0,completion: {
            SwiftSpinner.hide()
        })
        
    }
    
    
    
}


