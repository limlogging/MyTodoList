//
//  ViewController.swift
//  MyTodoList
//
//  Created by imhs on 3/19/24.
//

import UIKit


class ViewController: UIViewController {
    var myToDoListArray: [ToDoList] = []
    var rowCnt: Int = 0
    
    @IBOutlet weak var myTodoListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTodoListTableView.dataSource = self
    }
    
    // MARK: - alert 창 띄우기
    @IBAction func alertButtonTapped(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    // alert 창 띄우기
    func showAlert() {
        let alertController = UIAlertController(title: "할 일 추가", message: nil, preferredStyle: .alert)
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "할 일을 입력하세요."
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let toDoListAddButton = UIAlertAction(title: "추가", style: .default) {
            _ in
            // 사용자가 입력한 값을 확인하고 처리합니다.
            if let inputTextField = alertController.textFields?.first,
                let textt = inputTextField.text {
                print("입력된 값: \(textt)")
                self.rowCnt += 1
                self.myToDoListArray.append(ToDoList(toDoid: self.rowCnt, toDoTitle: textt, toDoIsComplete: false))
                print(self.myToDoListArray)
                self.myTodoListTableView.reloadData()   //테이블 뷰 리로드
            }
        }
        
        //버튼 추가 및 alert 창 띄우기
        alertController.addAction(cancelButton)
        alertController.addAction(toDoListAddButton)
        present(alertController, animated: true)
    }
}

//Table View DataSource
extension ViewController: UITableViewDataSource {
    //TableView에서 보여줄 Row 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myToDoListArray.count
    }
    
    //TableView Row에서 보여줄 컨텐츠
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyToDoListCell", for: indexPath) as! MyToDoListCell
        
        cell.myToDoIdLabel.text = String(myToDoListArray[indexPath.row].toDoid)
        cell.myToDoIsCompleteSwitch.isOn = myToDoListArray[indexPath.row].toDoIsComplete
        
        //switch true 일때 취소선 추가
        if cell.myToDoIsCompleteSwitch.isOn {
            // 해당 텍스트에 취소선을 적용한 NSAttributedString을 생성
            let attributedText = myToDoListArray[indexPath.row].toDoTitle.strikeThrough()
            // 취소선이 적용된 NSAttributedString을 텍스트로 설정
            cell.myToDoTitleLabel.attributedText = attributedText
        } else {
            //cell.myToDoTitleLabel.text = myToDoListArray[indexPath.row].toDoTitle
            cell.myToDoTitleLabel.attributedText = NSAttributedString(string: myToDoListArray[indexPath.row].toDoTitle)
        }
        
        print("hello5")
        cell.delegate = self    //스위치 값 변경 이벤트 처리를 위한 delegate 설정
        print("hello6")
        
        return cell
    }
}

//스위치 변경 이벤트 처리
extension ViewController: MyToDoListCellDelegate {
    func switchValueChanged(_ cell: MyToDoListCell, isOn: Bool) {
        //해당 셀의 인덱스 가져여오기
        guard let indexPath = myTodoListTableView.indexPath(for: cell) else {
            return
        }
        // 스위치 값을 배열에 반영
        myToDoListArray[indexPath.row].toDoIsComplete = isOn
        
        // 스위치가 변경될 때마다 테이블 뷰의 해당 셀만 다시 로드
        myTodoListTableView.reloadRows(at: [indexPath], with: .automatic)
                
        print("helloworld3")
        
    }
}

extension String {
    // MARK: - 밑줄
    func underScore() -> NSAttributedString {
        let underScore = NSMutableAttributedString(string: self)
        // 전체 문자열에 밑줄 스타일 속성을 추가
        underScore.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, underScore.length))
        return underScore
    }
    // MARK: - 취소선
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        // 전체 문자열에 취소선 스타일 속성을 추가
        // NSAttributedString.Key를 사용하여 서식과 속성을 적용할 수 있음(NSAttributedString.Key.strikethroughStyle을 .strikethroughStyle로 사용 가능)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
