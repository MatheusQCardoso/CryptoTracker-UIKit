//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Matheus Quirino on 09/01/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TableViewCoinCell.self,
                           forCellReuseIdentifier: TableViewCoinCell.identifier)
        return tableView
    }()
    
    private var viewModels = [TableViewCoinCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CryptoTracker"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        APICaller.shared.getAllCryptoData{ [weak self] result in
            switch result {
            case .success(let model):
                print("SUCCESS_ \(model[0])")
                self?.viewModels = model
                                    .filter({ $0.type_is_crypto == 1 })
                                    .sorted(by: { $0.price_usd ?? 0 > $1.price_usd ?? 0 })
                                    .compactMap({
                    let assetID = $0.asset_id
                    //PRICE
                    var price = "N/A"
                    if let priceValue = $0.price_usd {
                        price = PriceFormatter.shared.format(from: priceValue) ?? price
                    }
                    //ICON  
                    let iconURLString = APICaller.shared.icons.filter({ icon in
                        assetID == icon.asset_id
                    }).first?.url ?? ""
                    let iconURL = URL(string: iconURLString)
                    
                    
                    return TableViewCoinCellViewModel(name: $0.name ?? "N/A",
                                               symbol: assetID,
                                               price: price,
                                               iconURL: iconURL)
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                break
            case .failure(let error):
                print("ERR_ \(error)")
                break
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCoinCell.identifier,
                                                 for: indexPath) as? TableViewCoinCell else {
            fatalError()
        }
        cell.populate(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}

