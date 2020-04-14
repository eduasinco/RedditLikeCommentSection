//
//  ViewController.swift
//  try6
//
//  Created by eduardo rodríguez on 26/03/2020.
//  Copyright © 2020 Eduardo Rodríguez Pérez. All rights reserved.
//

import UIKit

let MAX_DEPTH = 8
let MAX_LENGTH = 3
let ACTUAL_DEPTH = 3
let ACTUAL_LENGTH = 3

class Comment {
    let id: Int!
    var comment: String!
    var comments: [Comment] = []
    var depth: Int!
    var parent: Comment?
    
    var isMaxDepth = false
    var isMaxLength = 0
    
    static var count = 0
    
    static func incrId() -> Int{
        self.count += 1
        return self.count
    }
    
    init(_ comment: String, _ depth: Int, _ parent: Comment?) {
        self.id = Comment.incrId()
        self.comment = comment
        self.depth = depth
        self.parent = parent
        // self.isMaxDepth = self.depth == MAX_DEPTH - 1

        guard let parent = self.parent else { return }
        parent.comments.append(self)
        if parent.comments.count == MAX_LENGTH {
            let maxLengthComment = Comment("", self.depth, parent)
            maxLengthComment.isMaxLength = 1 + Int(arc4random_uniform(2))
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    var _currentlyDisplayed: [Comment] = []
    var makeExpandedCellsVisible: Bool = true
    var currentCell: UITableViewCell?
    var comments: [Comment]!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        createRandomComments()
        linearizeComments(comments)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWriteComment"{
            let destVC = segue.destination as! WriteCommentViewController
            destVC.comment = sender as? Comment
            destVC.delegate = self
        }
    }
    func randomString() -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyz        "
        let mayus: NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
         let len = UInt32(letters.length)
         let len2 = UInt32(mayus.length)

        var randomString = ""
        let rand = arc4random_uniform(len2)
        var nextChar = mayus.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
        
        for _ in 0 ..< Int(arc4random_uniform(200)) {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    
    func createRandomComments(){
        let deep = ACTUAL_DEPTH
        let long = ACTUAL_LENGTH
        var comments: [Comment] = []
        
        for n in 0..<long{
            comments.append(Comment("0\(n) " + randomString(), 0, nil))
        }
        
        var d = 1
        var cc = comments
        while d < deep{
            var new_comments: [Comment] = []
            for comment in cc {
                for n in 0..<long{
                    let c = Comment("\(d)\(n) " + randomString(), d, comment)
                    new_comments.append(c)
                }
            }
            cc = new_comments
            d += 1
        }
        self.comments = comments
    }
    func linearizeComments(_ comments: [Comment]){
        var q: [Comment] = []
        for c in comments.reversed(){
            q.append(c)
        }
        while q.count > 0 {
            let c = q.popLast()
            _currentlyDisplayed.append(c!)
            for c in c!.comments.reversed(){
                q.append(c)
            }
        }
    }
    
    func subCommentsLinearized(_ comments: [Comment]) -> [Comment]{
        var q: [Comment] = []
        for c in comments.reversed(){
            q.append(c)
        }
        var linearizedComments: [Comment] = []
        while q.count > 0 {
            let c = q.popLast()
            linearizedComments.append(c!)
            for c in c!.comments.reversed(){
                q.append(c)
            }
        }
        return linearizedComments
    }
}
extension ViewController: AddCommentDelegate{
    func commentAdded(newComment: Comment) {
        let ip = self.tableView.indexPath(for: currentCell!)
        guard let indexPath = ip else { return }
        let selectedCom: Comment = _currentlyDisplayed[indexPath.row]
        let selectedIndex = indexPath.row

        // Do whatever you want from your button here.
        if !(self.isCellExpanded(indexPath: indexPath)){
            // expand
            var toShow: [Comment] = []
            toShow = selectedCom.comments
            self._currentlyDisplayed.insert(contentsOf: toShow, at: selectedIndex+1)
            var indexPaths: [IndexPath] = []
            for i in 0..<toShow.count {
                indexPaths.append(IndexPath(row: selectedIndex+i+1, section: indexPath.section))
            }
            tableView.insertRows(at: indexPaths, with: .bottom)
        } else {
            self._currentlyDisplayed.insert(newComment, at: selectedIndex+1)
            tableView.insertRows(at: [IndexPath(row: selectedIndex+1, section: indexPath.section)], with: .bottom)
        }
    }
}

extension ViewController: AddOrDeleteDelegate {
    func moreComments(comment: Comment, cell: UITableViewCell) {
        
    }
    
    func continueConversation(comment: Comment, cell: UITableViewCell) {
        
    }
    
    func add(comment: Comment, cell: UITableViewCell) {
        self.currentCell = cell
        performSegue(withIdentifier: "goToWriteComment", sender: comment)
    }
    
    func expand(comment: Comment, cell: UITableViewCell) {
        let ip = self.tableView.indexPath(for: cell)
        guard let indexPath = ip else { return }
        let selectedCom: Comment = _currentlyDisplayed[indexPath.row]
        let selectedIndex = indexPath.row

        // Do whatever you want from your button here.
        if !(self.isCellExpanded(indexPath: indexPath)){
            // expand
            var toShow: [Comment] = []
            toShow = self.subCommentsLinearized(selectedCom.comments)
            
            self._currentlyDisplayed.insert(contentsOf: toShow, at: selectedIndex+1)
            var indexPaths: [IndexPath] = []
            for i in 0..<toShow.count {
                indexPaths.append(IndexPath(row: selectedIndex+i+1, section: indexPath.section))
            }
            tableView.insertRows(at: indexPaths, with: .bottom)

            if self.makeExpandedCellsVisible && comment.comments.count > 0 {
                tableView.scrollToRow(at: IndexPath(row: selectedIndex+1, section: indexPath.section), at: UITableView.ScrollPosition.middle, animated: false)
            }
        }
    }

    func collapse(comment: Comment, cell: UITableViewCell) {
        // Do whatever you want from your button here.
        let ip = self.tableView.indexPath(for: cell)
        guard let indexPath = ip else { return }
        let selectedCom: Comment = _currentlyDisplayed[indexPath.row]
        let selectedIndex = indexPath.row

        if self.isCellExpanded(indexPath: indexPath) {
            // collapse
            var nCellsToDelete = 0
            while (_currentlyDisplayed.count > selectedIndex+nCellsToDelete+1 && _currentlyDisplayed[selectedIndex+nCellsToDelete+1].depth > selectedCom.depth){
                nCellsToDelete += 1
            }

            self._currentlyDisplayed.removeSubrange(Range(uncheckedBounds: (lower: selectedIndex+1 , upper: selectedIndex+nCellsToDelete+1)))
            var indexPaths: [IndexPath] = []
            for i in 0..<nCellsToDelete {
                indexPaths.append(IndexPath(row: selectedIndex+i+1, section: indexPath.section))
            }
            tableView.deleteRows(at: indexPaths, with: .bottom)
        }
    }

    func delete(comment: Comment, cell: UITableViewCell) {
        // Do whatever you want from your button here.
        let ip = self.tableView.indexPath(for: cell)
        guard let indexPath = ip else { return }
        let selectedCom: Comment = _currentlyDisplayed[indexPath.row]
        let selectedIndex = indexPath.row

        var nCellsToDelete = 0
        while (_currentlyDisplayed.count > selectedIndex+nCellsToDelete+1 && _currentlyDisplayed[selectedIndex+nCellsToDelete+1].depth > selectedCom.depth){
            nCellsToDelete += 1
        }
        _currentlyDisplayed.removeSubrange(Range(uncheckedBounds: (lower: selectedIndex , upper: selectedIndex+nCellsToDelete+1)))
        var indexPaths: [IndexPath] = []
        for i in 0...nCellsToDelete {
            indexPaths.append(IndexPath(row: selectedIndex+i, section: indexPath.section))
        }
        tableView.deleteRows(at: indexPaths, with: .bottom)
        
        if let parent = comment.parent {
            for (i, child) in parent.comments.enumerated(){
                if child.id == comment.id {
                    parent.comments.remove(at: i)
                    break
                }
            }
        } else {
            for (i, child) in self.comments.enumerated(){
                if child.id == comment.id {
                    self.comments.remove(at: i)
                    break
                }
            }
        }
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _currentlyDisplayed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.setCell(comment: _currentlyDisplayed[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    open func isCellExpanded(indexPath: IndexPath) -> Bool {
        let com: Comment = _currentlyDisplayed[indexPath.row]
        return _currentlyDisplayed.count > indexPath.row+1 &&  // if not last cell
            _currentlyDisplayed[indexPath.row+1].depth > com.depth // if replies are displayed
    }
}

class MyOwnTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
