//
//  DetailViewController.swift
//  MyTodoList
//
//  Created by imhs on 3/27/24.
//

import UIKit

protocol DetailViewControllerTitleDelegate: AnyObject {
    func textFieldDidChangeSelection(_ controller: DetailViewController, textField: String)
}
protocol DetailViewControllerDetailDelegate: AnyObject {
    func textViewDidChange(_ controller: DetailViewController, textView: String)
}

class DetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    
    //ViewController에서 전달 받은 데이터 저장
    var receiveTitle: String?
    var receiveDetail: String?
    var receiveIndexPath: Int?
    
    var indexPath: Int = 0
    
    //title, detail 이벤트를 처리할 델리게이트 
    var titleDelegate: DetailViewControllerTitleDelegate?
    var detailDelegate: DetailViewControllerDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = receiveTitle
        detailTextView.text = receiveDetail
        indexPath = receiveIndexPath!
        
        //테두리
        titleTextField.layer.borderColor = UIColor.black.cgColor
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.cornerRadius = 10
        detailTextView.layer.borderColor = UIColor.black.cgColor
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.cornerRadius = 10
        
        //델리게이트 설정
        titleTextField.delegate = self
        detailTextView.delegate = self
    }
}
// MARK: - 타이틀 처리를 위한 델리게이트
extension DetailViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == titleTextField {
            if textField.text != nil {
                titleDelegate?.textFieldDidChangeSelection(self, textField: textField.text!)
            }
        }
    }
}
// MARK: - 디테일 처리를 위한 델리게이트
extension DetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == detailTextView {
            if textView.text != nil {
                detailDelegate?.textViewDidChange(self, textView: textView.text)
            }
        }
    }
}
