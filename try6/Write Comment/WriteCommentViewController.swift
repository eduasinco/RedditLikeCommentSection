//
//  WriteCommentViewController.swift
//  try6
//
//  Created by eduardo rodríguez on 10/04/2020.
//  Copyright © 2020 Eduardo Rodríguez Pérez. All rights reserved.
//

import UIKit

protocol AddCommentDelegate {
    func commentAdded(newComment: Comment)
}

class WriteCommentViewController: KUIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bcfkb: NSLayoutConstraint!
    
    var comment: Comment!
    var originalHeight: CGFloat!
    
    var delegate: AddCommentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.isScrollEnabled = false
        originalHeight = self.view.frame.height
        self.bottomConstraintForKeyboard = bcfkb
    }
    
    @IBAction func submitPress(_ sender: Any) {
        let newComment = Comment(textView.text!, comment.depth + 1, comment)
        comment.comments.insert(newComment, at: 0)
        delegate?.commentAdded(newComment: newComment)
        self.dismiss(animated: true)
    }
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
