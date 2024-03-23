//
//  MyToDoListCell.swift
//  MyTodoList
//
//  Created by imhs on 3/22/24.
//

import UIKit

//스위치 값이 변경될때마다 해당 정보를 View Controller로 전달 할 수 있는 프로토콜을 정의
protocol MyToDoListCellDelegate: AnyObject {
    func switchValueChanged(_ cell: MyToDoListCell, isOn: Bool) // 스위치 값 변경 시 호출할 메서드
}

class MyToDoListCell: UITableViewCell {
    @IBOutlet weak var myToDoIdLabel: UILabel!              //할 일 id
    @IBOutlet weak var myToDoTitleLabel: UILabel!           //할 일 제목
    @IBOutlet weak var myToDoIsCompleteSwitch: UISwitch!    //할 일 완료 여부 스위치
    
    var delegate: MyToDoListCellDelegate?   //스위치 값 변경 이벤트를 처리할 delegate
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 스위치의 값이 변경될 때 switchValueChanged 메서드 호출
        print("helloworld1")
        myToDoIsCompleteSwitch.addTarget(self, action: #selector(switchValueChanged(sender: )), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //스위치 변경 이벤트
    @objc func switchValueChanged(sender: UISwitch) {
//        // 해당 셀이 속한 테이블 뷰와 인덱스 판별
//        guard let superview = self.superview as? UITableView, // 부모 뷰가 UITableView인지 확인
//               let indexPath = superview.indexPath(for: self) else { // 셀의 indexPath 가져오기
//             return
//         }
        print("helloworld2")
        // // delegate를 통해 스위치 값 변경 이벤트 전달
        delegate?.switchValueChanged(self, isOn: sender.isOn)
        
        
    }
}
