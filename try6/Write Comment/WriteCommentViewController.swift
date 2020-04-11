//
//  WriteCommentViewController.swift
//  try6
//
//  Created by eduardo rodríguez on 10/04/2020.
//  Copyright © 2020 Eduardo Rodríguez Pérez. All rights reserved.
//

import UIKit

class WriteCommentViewController: KUIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bcfkb: NSLayoutConstraint!
    
    var comment: Comment!
    var originalHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.isScrollEnabled = false
        originalHeight = self.view.frame.height
        self.bottomConstraintForKeyboard = bcfkb
        // commentLabel.text = self.comment.comment
//        NotificationCenter.default.addObserver(self, selector: #selector(WriteCommentViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(WriteCommentViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            print("showwwwwww")
//            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: originalHeight - keyboardSize.height)
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        print("hideeeeee")
//        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: originalHeight)
//    }
}
extension WriteCommentViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
}
