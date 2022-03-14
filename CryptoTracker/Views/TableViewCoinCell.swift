//
//  File.swift
//  CryptoTracker
//
//  Created by Matheus Quirino on 09/01/22.
//

import Foundation
import UIKit

struct TableViewCoinCellViewModel{
    let name: String
    let symbol: String
    let price: String
    let iconURL: URL?
    var iconData: Data?
    
    init(name: String,
         symbol: String,
         price: String,
         iconURL: URL?){
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconURL = iconURL
        
    }
}

class TableViewCoinCell: UITableViewCell {
    static let identifier = "TableViewCoinCell"
    
    private var viewModel: TableViewCoinCellViewModel?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemGreen
        label.textAlignment = .right
        return label
    }()
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "image-placeholder")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(iconView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        symbolLabel.sizeToFit()
        
        let iconSize = contentView.frame.size.height/1.1 - 10
        
        iconView.frame = CGRect(x: 10,
                                 y: 10,
                                 width: iconSize,
                                 height: iconSize)
        
        nameLabel.frame = CGRect(x: 25 + iconSize,
                                 y: 0,
                                 width: (contentView.frame.width/2 + iconSize),
                                 height: contentView.frame.height/2)
        priceLabel.frame = CGRect(x: 25 + iconSize,
                                  y: contentView.frame.height/2,
                                  width: (contentView.frame.width/2 + iconSize),
                                  height: contentView.frame.height/2)
        symbolLabel.frame = CGRect(x: contentView.frame.width - contentView.frame.height,
                                  y: 0,
                                   width: contentView.frame.height,
                                   height: contentView.frame.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        symbolLabel.text = nil
    }
    
    func populate(with model: TableViewCoinCellViewModel){
        self.viewModel = model
        self.nameLabel.text = model.name
        self.symbolLabel.text = model.symbol
        self.priceLabel.text = model.price
                
        
        if let data = model.iconData {
            self.iconView.image = UIImage(data: data)
        } else {
            if let url = model.iconURL {
                let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
                    if let data = data {
                        self?.viewModel?.iconData = data
                        DispatchQueue.main.async {
                            self?.iconView.image = UIImage(data: data)
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
}
