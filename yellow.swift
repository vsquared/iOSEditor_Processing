import UIKit

class ViewController: UIViewController {
   let label = UILabel()

   override func viewDidLoad() {
     super.viewDidLoad()
     view.backgroundColor = .yellow
     // Additional setup
     label.frame = CGRect(x: 20, y: 140, width: self.view.frame.width, height: 20)
     label.text = "Hello World!!!!!!."
     self.view.addSubview(label)
    }
}

let viewController = ViewController()

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     window = UIWindow(frame: UIScreen.main.bounds)
     window?.rootViewController = viewController
     window?.makeKeyAndVisible()

     return true
    }
}

UIApplicationMain( CommandLine.argc,  CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
