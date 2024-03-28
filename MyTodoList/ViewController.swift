//
//  ViewController.swift
//  MyTodoList
//
//  Created by imhs on 3/19/24.
//

import UIKit

class ViewController: UIViewController {
    //var myToDoListArray: [ToDoList] = []
    var myToDoListArray: [ToDoList] = [
        ToDoList(toDoid: 1, toDoTitle: "아침먹기", toDoIsComplete: false, toDoDetail: "시리얼, 우유, 홍삼, 영양제"),
        ToDoList(toDoid: 2, toDoTitle: "알고리즘 문제", toDoIsComplete: false, toDoDetail: "프로그래머스"),
        ToDoList(toDoid: 3, toDoTitle: "개인과제", toDoIsComplete: false, toDoDetail: "View Controller, Table View"),
        ToDoList(toDoid: 4, toDoTitle: "점심먹기", toDoIsComplete: false, toDoDetail: "된장찌개, 아이스 아메리카노"),
        ToDoList(toDoid: 4, toDoTitle: "독서", toDoIsComplete: false, toDoDetail: "iOS관련"),
        ToDoList(toDoid: 5, toDoTitle: "저녁먹기", toDoIsComplete: false, toDoDetail: "외식, 초밥"),
        ToDoList(toDoid: 6, toDoTitle: "오늘 하루 회고", toDoIsComplete: false, toDoDetail: "오늘 한일 ?"),
        ToDoList(toDoid: 7, toDoTitle: "Til 작성", toDoIsComplete: false, toDoDetail: "오늘의 TIL?")
        
    ]
    var rowCnt: Int = 0
    
    @IBOutlet weak var myTodoListTableView: UITableView!
    @IBOutlet weak var myTodoTotalLabel: UILabel!
    @IBOutlet weak var myToDoCompleteCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTodoListTableView.dataSource = self
        myTodoListTableView.delegate = self
        
        //합계 및 완료
        myTodoTotalLabel.text = String(myToDoListArray.count)
        myToDoCompleteCount.text = String(myToDoListArray.filter({ $0.toDoIsComplete == true }).count)
    }
    
    // MARK: - alert 창 띄우기
    @IBAction func alertButtonTapped(_ sender: UIBarButtonItem) {
        showAddAlert()
    }
       
    // MARK: - edit 창 선택
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        //print(myTodoListTableView.isEditing)
        //편집 모드와 버튼의 Text는 서로 반대
        if myTodoListTableView.isEditing {
            // 편집 모드 해제
            myTodoListTableView.setEditing(false, animated: true)
            // 새로운 UIBarButtonItem 생성하여 Edit 버튼으로 설정
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
            navigationItem.leftBarButtonItem = editButton
        } else {
            // 편집 모드 활성화
            myTodoListTableView.setEditing(true, animated: true)
            
            // 새로운 UIBarButtonItem 생성하여 Done 버튼으로 설정
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editButtonTapped(_:)))
            navigationItem.leftBarButtonItem = doneButton
        }
    }
    
    // MARK: - alert 창 띄우기
    func showAddAlert() {
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
                
                self.rowCnt = self.myToDoListArray.count + 1
                
                self.myToDoListArray.append(ToDoList(toDoid: self.rowCnt, toDoTitle: textFieldText, toDoIsComplete: false, toDoDetail: ""))
                
                //print(self.myToDoListArray)
                self.myTodoTotalLabel.text = String(self.myToDoListArray.count) //추가하고 총합 수정
                self.myTodoListTableView.reloadData()   //테이블 뷰 리로드
            }
        }
        //버튼 추가 및 alert 창 띄우기
        alertController.addAction(cancelButton)
        alertController.addAction(toDoListAddButton)
        present(alertController, animated: true)
    }
    
    //스토리보드에서의 화면 이동
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDoDetailSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = self.myTodoListTableView.indexPath(for: cell)
            let detailView = segue.destination as! DetailViewController
            detailView.receiveTitle = myToDoListArray[indexPath!.row].toDoTitle
            detailView.receiveDetail = myToDoListArray[indexPath!.row].toDoDetail
            detailView.receiveIndexPath = indexPath!.row
            detailView.titleDelegate = self     //타이틀처리를 위한 TextField 델리게이트
            detailView.detailDelegate = self    //디테일처리를 위한 TextView 델리게이트
        }
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
        cell.myToDoIsCompleteSwitch.isOn = myToDoListArray[indexPath.row].toDoIsComplete
        
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
        cell.myToDoDetailLabel.text = myToDoListArray[indexPath.row].toDoDetail //디테일 추가
        
        cell.delegate = self    //스위치 값 변경 이벤트 처리를 위한 delegate 설정
        return cell
    }
}

// MARK: - TableView Delegate 채택
extension ViewController: UITableViewDelegate {
    // MARK: - 목록 순서 변경
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //print("sourceIndexPath: \(sourceIndexPath.row), destinationIndexPath: \(destinationIndexPath.row)")
        //현재 row(출발지)의 cell 데이터 저장
        let sourceId = myToDoListArray[sourceIndexPath.row].toDoid
        let sourceTitle = myToDoListArray[sourceIndexPath.row].toDoTitle
        let sourceIsComplete = myToDoListArray[sourceIndexPath.row].toDoIsComplete
        let sourceIsDetail = myToDoListArray[sourceIndexPath.row].toDoDetail
        
        //선택한 row 배열에서 삭제
        myToDoListArray.remove(at: sourceIndexPath.row)
        
        //이동한 위치에 출발지 cell 데이터를 배열의 목적지 index 위치에 추가
        myToDoListArray.insert(ToDoList(toDoid: sourceId, toDoTitle: sourceTitle, toDoIsComplete: sourceIsComplete, toDoDetail: sourceIsDetail), at: destinationIndexPath.row)
    
        //print("목록 변경 후: \(myToDoListArray)")
        myTodoListTableView.reloadData()    //변경사항 확인을 위해 새로고침
    }
    
    // MARK: - 스와이프 수정 / 삭제 기능
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                
        // 삭제 액션 설정
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler) in
            let alertController = UIAlertController(title: "삭제 확인", message: "삭제하시겠습니까?", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            let deleteButton = UIAlertAction(title: "삭제", style: .default) { _ in
                // 데이터 소스에서 해당 셀에 대한 데이터를 삭제
                self.myToDoListArray.remove(at: indexPath.row)
                // 테이블 뷰에서 해당 셀을 삭제
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                //전체 수 및 완료 다시 불러오기
                self.myTodoTotalLabel.text = String(self.myToDoListArray.count)
                self.myToDoCompleteCount.text = String(self.myToDoListArray.filter({ $0.toDoIsComplete == true }).count)
            }
            alertController.addAction(cancelButton)
            alertController.addAction(deleteButton)
            self.present(alertController, animated: true)
        
            // 처리 완료 핸들러 호출
            completionHandler(true)
        }
        
        // 수정 액션 설정
        let editAction = UIContextualAction(style: .normal, title: "Title 수정") { (action, view, completionHandler) in
            let alertController = UIAlertController(title: "할 일 입력", message: "", preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.text = self.myToDoListArray[indexPath.row].toDoTitle
            }
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            let editButton = UIAlertAction(title: "수정", style: .default) { _ in
                if let editTextField = alertController.textFields?.first,
                   let text = editTextField.text {
                    self.myToDoListArray[indexPath.row].toDoTitle = text
                    // 수정됐는지 확인하기 위해 row 새로고침
                    self.myTodoListTableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            alertController.addAction(cancelButton)
            alertController.addAction(editButton)
            self.present(alertController, animated: true)
            
            completionHandler(true)
        }
        
        // 버튼들을 배열로 묶어서 스와이프 액션 구성
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        // 스와이프 액션 구성 반환
        return swipeConfiguration
    }
}

// MARK: - 스위치 변경 이벤트 처리를 위한 Delegate 채택
extension ViewController: MyToDoListCellDelegate {
    func switchValueChanged(_ cell: MyToDoListCell, isOn: Bool) {
        //해당 셀의 인덱스 가져여오기
        guard let indexPath = myTodoListTableView.indexPath(for: cell) else { return }
        //print("cell index: \(indexPath)") //ex [0, 1]
        
        // 스위치 값을 배열에 반영
        myToDoListArray[indexPath.row].toDoIsComplete = isOn
        // 스위치가 변경될 때마다 테이블 뷰의 해당 셀만 다시 로드, 취소선 때문에
        myTodoListTableView.reloadRows(at: [indexPath], with: .automatic)
        myToDoCompleteCount.text = String(myToDoListArray.filter({ $0.toDoIsComplete == true }).count)
    }
}
// MARK: - 디테일 뷰에서 타이틀 입력
extension ViewController: DetailViewControllerTitleDelegate {
    func textFieldDidChangeSelection(_ controller: DetailViewController, textField: String) {
        if let indexPath = controller.receiveIndexPath {
            myToDoListArray[indexPath].toDoTitle = textField    //타이틀 자동저장
            self.myTodoListTableView.reloadData()   //테이블 뷰 리로드
        }
    }
}
// MARK: - 디테일 뷰에서 디테일 입력
extension ViewController: DetailViewControllerDetailDelegate {
    func textViewDidChange(_ controller: DetailViewController, textView: String) {
        if let indexPath = controller.receiveIndexPath {
            myToDoListArray[indexPath].toDoDetail = textView    //디테일 자동저장
            self.myTodoListTableView.reloadData()   //테이블 뷰 리로드
        }
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

