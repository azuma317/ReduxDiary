//
//  DiaryCell.swift
//  ReduxDiary
//
//  Created by Azuma on 2019/09/08.
//

import UIKit

class DiaryCell: UITableViewCell {

    @IBOutlet private weak var diaryDateLabel: UILabel!
    @IBOutlet private weak var updatedLabel: UILabel!
    
    func configure(_ diary: DiaryItem) {
        diaryDateLabel.text = diary.text
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale.current)
        updatedLabel.text = formatter.string(from: diary.updatedAt)
    }

}
