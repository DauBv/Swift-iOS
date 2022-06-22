//
//  ViewController.swift
//  Demo-SpreadsheetView
//
//  Created by VINICORP JSC on 22/06/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    var header = [String]()
    var data = [[String]]()

    enum Sorting {
        case ascending
        case descending

        var symbol: String {
            switch self {
            case .ascending:
                return "\u{25B2}"
            case .descending:
                return "\u{25BC}"
            }
        }
    }
    var sortedColumn = (column: 0, sorting: Sorting.ascending)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self

        spreadsheetView.register(HeaderCell.self, forCellWithReuseIdentifier: String(describing: HeaderCell.self))
        spreadsheetView.register(TextCell.self, forCellWithReuseIdentifier: String(describing: TextCell.self))

        let data = try! String(contentsOf: Bundle.main.url(forResource: "data", withExtension: "tsv")!, encoding: .utf8)
            .components(separatedBy: "\r\n")
            .map { $0.components(separatedBy: "\t") }
        header = data[0]
        self.data = Array(data.dropFirst())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }
}

//Extension SpreadsheetViewDataSource, SpreadsheetViewDelegate
extension ViewController: SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    // MARK: DataSource

    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return header.count
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + data.count
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 140
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
//        if case 0 = row {
//            return 60
//        } else {
//            return 44
//        }
        return 40
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        return [CellRange(from: (row: 0, column: 1), to: (row: 0, column: 2)),
                CellRange(from: (row: 0, column: 1), to: (row: 0, column: 3)),
                CellRange(from: (row: 0, column: 4), to: (row: 1, column: 4)),
                CellRange(from: (row: 0, column: 0), to: (row: 1, column: 0)),
                CellRange(from: (row: 0, column: 5), to: (row: 1, column: 5))
        ]
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        switch indexPath.row {
        case 0, 1:
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            cell.label.text = header[indexPath.column]
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    cell.label.textColor = .white
                } else {
                    cell.label.textColor = .black
                }
            }
            if case indexPath.column = sortedColumn.column {
                cell.sortArrow.text = sortedColumn.sorting.symbol
            } else {
                cell.sortArrow.text = ""
            }
            cell.setNeedsLayout()
            
            return cell
        default:
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextCell.self), for: indexPath) as! TextCell
            cell.label.text = data[indexPath.row - 1][indexPath.column]
            if indexPath.row % 2 == 0 {
                if #available(iOS 13.0, *) {
                    cell.backgroundColor = .systemGray5
                } else {
                    // Fallback on earlier versions
                }
            } else {
                cell.backgroundColor = .clear
            }
            return cell
        }
    }

    /// Delegate

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        if case 0 = indexPath.row {
            if sortedColumn.column == indexPath.column {
                sortedColumn.sorting = sortedColumn.sorting == .ascending ? .descending : .ascending
            } else {
                sortedColumn = (indexPath.column, .ascending)
            }
            data.sort {
                let ascending = $0[sortedColumn.column] < $1[sortedColumn.column]
                return sortedColumn.sorting == .ascending ? ascending : !ascending
            }
            spreadsheetView.reloadData()
        }
    }
}

