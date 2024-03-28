//
//  DetailViewController.swift
//  MyTodoList
//
//  Created by imhs on 3/27/24.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func textViewDidChange(_ controller: DetailViewController, textView: String)
}

class DetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    //@IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    
    var receiveTitle: String?
    var receiveDetail: String?
    var receiveIndexPath: Int?
    
    var indexPath: Int = 0
    
    var delegate: DetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = receiveTitle
        detailTextView.text = receiveDetail
        indexPath = receiveIndexPath!
        
        // 테두리 색상 설정
        titleTextField.layer.borderColor = UIColor.black.cgColor
        // 테두리 두께 설정
        titleTextField.layer.borderWidth = 1.0
        // 테두리를 둥글게 만듭니다.
        titleTextField.layer.cornerRadius = 10
        
        // 테두리 색상 설정
        detailTextView.layer.borderColor = UIColor.black.cgColor
        // 테두리 두께 설정
        detailTextView.layer.borderWidth = 1.0
        // 테두리를 둥글게 만듭니다.
        detailTextView.layer.cornerRadius = 10
        
        detailTextView.delegate = self
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == detailTextView {
            if let text = textView.text {
                delegate?.textViewDidChange(self, textView: textView.text)
            }
        }
    }
}
