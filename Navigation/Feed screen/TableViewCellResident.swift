//
//  TableViewCellResident.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation
import UIKit

class TableViewCellResident: UITableViewCell {
    lazy var nameResident: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.tintColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
}

extension TableViewCellResident {
    private func setupViews() {
        contentView.addSubview(nameResident)
    }
}

extension TableViewCellResident {
    private func setupConstraints() {
        [
            nameResident.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameResident.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameResident.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
        .forEach {$0.isActive = true}
    }
}
