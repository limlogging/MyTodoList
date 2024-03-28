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
    @IBOutlet weak var myToDoTitleLabel: UILabel!           //할 일 제목
    @IBOutlet weak var myToDoIsCompleteSwitch: UISwitch!    //할 일 완료 여부 스위치
    @IBOutlet weak var myToDoDetailLabel: UILabel!          //할일 상세내용
    
    var delegate: MyToDoListCellDelegate?   //스위치 값 변경 이벤트를 처리할 delegate
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //스위치 변경 이벤트
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        // delegate를 통해 스위치 값 변경 이벤트 전달
        delegate?.switchValueChanged(self, isOn: sender.isOn)
    }
}
