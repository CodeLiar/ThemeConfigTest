//
//  ViewController.swift
//  ThemeConfigTest
//
//  Created by Geass on 2/21/17.
//  Copyright © 2017 Geass. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let myView = MyView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    myView.themeConfig { (myView) in
      myView.backgroundColor = arc4random() % 2 == 0 ? .red : .blue
    }
    self.view.addSubview(myView)
  }
  
  @IBAction func btnAction(_ sender: Any) {
    for view in self.view.subviews {
      if view.theme != nil {
        UIView.animate(withDuration: 10, animations: {
          view.theme?.config?(view)
        })
      }
    }
  }
  
  @IBAction func removeAction(_ sender: Any) {
    for view in self.view.subviews {
      if view.isKind(of: MyView.self) {
        view.removeFromSuperview()
      }
    }
  }
  
}

class MyView: UIView {
  deinit {
    print(#function)
  }
}

typealias ThemeConfig<T> = (T) -> Void
private var xoAssociationKey: UInt8 = 0
extension UIView {
  
  internal class Theme: NSObject {
    var config: ThemeConfig<UIView>?
    class func theme(ofConfig config:@escaping ThemeConfig<UIView>) -> Theme? {
      let theme = Theme()
      theme.config = config
      return theme
    }
  }
  
  internal var theme: Theme? {
    get {
      return objc_getAssociatedObject(self, &xoAssociationKey) as? Theme
    }
    set(newValue) {
      objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
  
  func themeConfig(_ config:@escaping (UIView) -> Void) {
    config(self)
    self.theme = Theme.theme(ofConfig: config)
  }
  
}

