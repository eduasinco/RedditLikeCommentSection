//
//  KUIViewController.swift
//  try6
//
//  Created by eduardo rodríguez on 10/04/2020.
//  Copyright © 2020 Eduardo Rodríguez Pérez. All rights reserved.
//

import UIKit

class KUIViewController: UIViewController {

    // KBaseVC is the KEYBOARD variant BaseVC. more on this later

    @IBOutlet var bottomConstraintForKeyboard: NSLayoutConstraint!

    @objc func keyboardWillShow(sender: NSNotification) {
        let i = sender.userInfo!
        let k = (i[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        bottomConstraintForKeyboard.constant = k - bottomLayoutGuide.length
        let s: TimeInterval = (i[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let s: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        bottomConstraintForKeyboard.constant = 0
        UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
    }

    @objc func clearKeyboard() {
        view.endEditing(true)
    }

    func keyboardNotifications() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardNotifications()
        let t = UITapGestureRecognizer(target: self, action: #selector(clearKeyboard))
        view.addGestureRecognizer(t)
        t.cancelsTouchesInView = false
    }
}


extension UIView {

    // MARK: visibility methods

    public enum Visibility : Int {
        case visible = 0
        case invisible = 1
        case gone = 2
        case goneY = 3
        case goneX = 4
    }

    public var visibility: Visibility {
        set {
            switch newValue {
                case .visible:
                    isHidden = false
                    getConstraintY(false)?.isActive = false
                    getConstraintX(false)?.isActive = false
                case .invisible:
                    isHidden = true
                    getConstraintY(false)?.isActive = false
                    getConstraintX(false)?.isActive = false
                case .gone:
                    isHidden = true
                    getConstraintY(true)?.isActive = true
                    getConstraintX(true)?.isActive = true
                case .goneY:
                    isHidden = true
                    getConstraintY(true)?.isActive = true
                    getConstraintX(false)?.isActive = false
                case .goneX:
                    isHidden = true
                    getConstraintY(false)?.isActive = false
                    getConstraintX(true)?.isActive = true
            }
        }
        get {
            if isHidden == false {
                return .visible
            }
            if getConstraintY(false)?.isActive == true && getConstraintX(false)?.isActive == true {
                return .gone
            }
            if getConstraintY(false)?.isActive == true {
                return .goneY
            }
            if getConstraintX(false)?.isActive == true {
                return .goneX
            }
            return .invisible
        }
    }

    fileprivate func getConstraintY(_ createIfNotExists: Bool = false) -> NSLayoutConstraint? {
        return getConstraint(.height, createIfNotExists)
    }

    fileprivate func getConstraintX(_ createIfNotExists: Bool = false) -> NSLayoutConstraint? {
        return getConstraint(.width, createIfNotExists)
    }

    fileprivate func getConstraint(_ attribute: NSLayoutConstraint.Attribute, _ createIfNotExists: Bool = false) -> NSLayoutConstraint? {
        let identifier = "random_id"
        var result: NSLayoutConstraint? = nil
        for constraint in constraints {
            if constraint.identifier == identifier {
                result = constraint
                break
            }
        }
        if result == nil && createIfNotExists {
            // create and add the constraint
            result = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 0)
            result?.identifier = identifier
            addConstraint(result!)
        }
        return result
    }
}
