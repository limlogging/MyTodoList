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
        myTodoListTableView.delegate = self
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem //상단 Navigation bar 왼쪽에 Edit 버튼 추가
    }
    
    // MARK: - alert 창 띄우기
    @IBAction func alertButtonTapped(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    
    // MARK: - alert 창 띄우기
    func showAlert() {
        let alertController = UIAlertController(title: "할 일 추가", message: nil, preferredStyle: .alert)
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "할 일을 입력하세요."
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let toDoListAddButton = UIAlertAction(title: "추가", style: .default) {
            _ in
            //TextField가 있을 수도 있고 없을 수도 있어서 옵셔널 타입, Alert에 TextField는 1개 이상 사용 가능한데 1개인 경우 .first
            if let inputTextField = alertController.textFields?.first,
                let textFieldText = inputTextField.text {
                self.rowCnt += 1
                self.myToDoListArray.append(ToDoList(toDoid: self.rowCnt, toDoTitle: textFieldText, toDoIsComplete: false))
                print(self.myToDoListArray)
                
                self.myTodoListTableView.reloadData()   //테이블 뷰 리로드
            }
        }
        
        //버튼 추가 및 alert 창 띄우기
        alertController.addAction(cancelButton)
        alertController.addAction(toDoListAddButton)
        present(alertController, animated: true)
    }
    
    // MARK: - TableView 스와이프(swipe) 삭제, 메서드 자동 완성이 안되는듯?
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "삭제 확인", message: "삭제하시겠습니까?", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            let deleteButton = UIAlertAction(title: "삭제", style: .default) { _ in
                //해당 indexPath에 위치한 데이터를 배열에서 제거
                self.myToDoListArray.remove(at: indexPath.row)
                // 테이블 뷰에서 해당 행을 애니메이션과 함께 삭제
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            alertController.addAction(cancelButton)
            alertController.addAction(deleteButton)
            present(alertController, animated: true, completion: nil)
        } else if editingStyle == .insert {
        }
    }
    // MARK: - 삭제 글자 변경 Delete -> 삭제
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}

// MARK: - TableView DataSource 채택
extension ViewController: UITableViewDataSource {
    // MARK: - TableView에서 보여줄 Row 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myToDoListArray.count
    }
    // MARK: - TableView Row에서 보여줄 컨텐츠
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell 타입이 UITableViewCell이라 UITableViewCell을 상속받는 MyToDoListCell로 다운캐스팅 필요
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyToDoListCell", for: indexPath) as! MyToDoListCell
        
        //cell.myToDoIdLabel.text = String(myToDoListArray[indexPath.row].toDoid)
        cell.myToDoIsCompleteSwitch.isOn = myToDoListArray[indexPath.row].toDoIsComplete
        
        //title 취소선 - 기존 코드 주석
        //cell.myToDoTitleLabel.text = myToDoListArray[indexPath.row].toDoTitle
        
        //title 취소선 - switch 값에 따라 취소선 또는 일반 Text
        if cell.myToDoIsCompleteSwitch.isOn {
            // 해당 텍스트에 취소선을 적용한 NSAttributedString을 생성
            let attributedText = myToDoListArray[indexPath.row].toDoTitle.strikeThrough()
            // 취소선이 적용된 NSAttributedString을 텍스트로 설정
            cell.myToDoTitleLabel.attributedText = attributedText
        } else {
            //일반 Text - 취소선 없애기
            cell.myToDoTitleLabel.attributedText = NSAttributedString(string: myToDoListArray[indexPath.row].toDoTitle)
        }
        
        cell.delegate = self    //스위치 값 변경 이벤트 처리를 위한 delegate 설정
        return cell
    }
}

// MARK: - 스위치 변경 이벤트 처리를 위한 Delegate 채택
extension ViewController: MyToDoListCellDelegate {
    func switchValueChanged(_ cell: MyToDoListCell, isOn: Bool) {
        //해당 셀의 인덱스 가져여오기
        guard let indexPath = myTodoListTableView.indexPath(for: cell) else {
            return
        }
        //print("cell index: \(indexPath)") //ex [0, 1]
        
        // 스위치 값을 배열에 반영
        myToDoListArray[indexPath.row].toDoIsComplete = isOn
        // 스위치가 변경될 때마다 테이블 뷰의 해당 셀만 다시 로드, 취소선 때문에
        myTodoListTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ViewController: UITableViewDelegate {
    //navigation bar edit Button 클릭 시
    override func setEditing(_ editing: Bool, animated: Bool) {
        //super.setEditing(editing, animated: animated) //없어도 되는뎅.. ?
        myTodoListTableView.setEditing(editing, animated: true)
    }
}

// MARK: - String 확장(extension) 메서드에 취소선 구현
extension String {
    func strikeThrough() -> NSAttributedString {
        // NSAttributedString.Key를 사용하여 서식과 속성을 적용할 수 있음(NSAttributedString.Key.strikethroughStyle을 .strikethroughStyle로 사용 가능)
        let attributeString = NSMutableAttributedString(string: self)
        // 전체 문자열에 취소선 스타일 속성을 추가
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
