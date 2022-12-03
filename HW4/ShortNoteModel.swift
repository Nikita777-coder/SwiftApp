//
//  ShortNodeModel.swift
//  HW4
//
//  Created by Nikita on 22.11.2022.
//

import UIKit

struct ShortNote {
    var text: String
}

final class NoteCell: UITableViewCell {
    static let reuseIdentifier = "NoteCell"
    private var textlabel = UILabel()
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupView() {
        textlabel.font = .systemFont(ofSize: 16, weight: .regular)
        textlabel.textColor = .label
        textlabel.numberOfLines = 0
        textlabel.backgroundColor = .clear
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(textlabel)
        textlabel.pin(to: contentView, [.left: 16, .top: 16, .right: 16, .bottom: 16])
        
        
    }
    
    public func configure(_ note: ShortNote) {
        textlabel.text = note.text
    }
}

