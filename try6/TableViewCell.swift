//
//  TableViewCell.swift
//  try6
//
//  Created by eduardo rodríguez on 08/04/2020.
//  Copyright © 2020 Eduardo Rodríguez Pérez. All rights reserved.
//

import UIKit

protocol AddOrDeleteDelegate {
    func expand(comment: Comment, cell: UITableViewCell)
    func collapse(comment: Comment, cell: UITableViewCell)
    func add(comment: Comment, cell: UITableViewCell)
    func delete(comment: Comment, cell: UITableViewCell)
    func moreComments(comment: Comment, cell: UITableViewCell)
    func continueConversation(comment: Comment, cell: TableViewCell)
}

class TableViewCell: UITableViewCell {
    
    var tableHeightAnchor: NSLayoutConstraint!
    var comment: Comment?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var leadingStackView: NSLayoutConstraint!
    
    @IBOutlet weak var moreCommentsButton: UIButton!
    @IBOutlet weak var leadingMoreComments: NSLayoutConstraint!
    
    @IBOutlet weak var continueConversationButton: UIButton!
    @IBOutlet weak var leadingContinueConversation: NSLayoutConstraint!
    
    var delegate: AddOrDeleteDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addPress(_ sender: Any) {
        self.delegate?.add(comment: self.comment!, cell: self)
    }
    @IBAction func deletePress(_ sender: Any) {
        self.delegate?.delete(comment: self.comment!, cell: self)
    }
    @IBAction func expandPress(_ sender: Any) {
                self.delegate?.expand(comment: self.comment!, cell: self)
    }
    @IBAction func collapsePress(_ sender: Any) {
                self.delegate?.collapse(comment: self.comment!, cell: self)
    }
    @IBAction func continueConversation(_ sender: Any) {
        self.delegate?.continueConversation(comment: self.comment!, cell: self)

    }
    @IBAction func loadMoreComments(_ sender: Any) {
        self.delegate?.moreComments(comment: self.comment!, cell: self)
    }
    
    func setCell(comment: Comment){
        self.comment = comment
        
        leadingStackView.constant = CGFloat(comment.depth * 32)
        leadingMoreComments.constant = CGFloat(comment.depth * 32)
        leadingContinueConversation.constant = CGFloat(comment.depth * 32)
        self.label.text = comment.comment
        
        stackView.visibility = .visible
        continueConversationButton.visibility = .gone
        moreCommentsButton.visibility = .gone
        
        if comment.isMaxLength > 0 {
            stackView.visibility = .gone
            continueConversationButton.visibility = .gone
            moreCommentsButton.visibility = .visible
            moreCommentsButton.setTitle("\(comment.isMaxLength) more comments...", for: .normal)
        }
        
        if comment.isMaxDepth {
            stackView.visibility = .gone
            continueConversationButton.visibility = .visible
            moreCommentsButton.visibility = .gone
        }
    }
    
    func getCellHeight() -> CGFloat{
        return self.contentView.frame.height
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
