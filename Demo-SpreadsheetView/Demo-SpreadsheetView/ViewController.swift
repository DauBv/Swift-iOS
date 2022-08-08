//
//  ViewController.swift
//  Demo-SpreadsheetView
//
//  Created by VINICORP JSC on 22/06/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
//    var header = [String]()
    var header: [String] = [
        "No", "Transaction ID", "DLR name", "Customer name", "Phone No", "Detail Address", "District", "Province/City", "Service date", "Sale BP",
        "Service BP", "Service quotation","SC in charge", "Walk in date", "DBM order", "MTO", "Status of take care", "Reason for not take care", "SC data entry time"
    ]
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
//        header = data[0]
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
//        return [CellRange(from: (row: 0, column: 1), to: (row: 0, column: 2)),
//                CellRange(from: (row: 0, column: 1), to: (row: 0, column: 3)),
//                CellRange(from: (row: 0, column: 4), to: (row: 1, column: 4)),
//                CellRange(from: (row: 0, column: 0), to: (row: 1, column: 0)),
//                CellRange(from: (row: 0, column: 5), to: (row: 1, column: 5))
//        ]
        return [
            CellRange(from: (row: 0, column: 0), to: (row: 1, column: 0)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 2)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 3)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 4)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 5)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 6)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 7)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 8)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 9)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 10)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 11)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 12)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 13)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 14)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 15)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 16)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 17)),
            CellRange(from: (row: 0, column: 1), to: (row: 0, column: 18)),
        ]
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        switch indexPath.row {
        case 0:
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            if indexPath.column > 0 {
                cell.label.text = "F.U REPORT RESULT MONTHLY"
            } else {
                cell.label.text = header[indexPath.column]
            }
            return cell
        case 1:
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
            if indexPath.column > 0 {
                cell.setTextAlignment(isText: false)
                if indexPath.row - 1 < data.count {
                    let data = data[indexPath.row - 1]
                    if indexPath.column < data.count {
                        cell.label.text = data[indexPath.column - 1]
                    } else {
                        cell.label.text = "-"
                    }
                }
            } else {
                cell.setTextAlignment(isText: true)
                cell.label.text = "\(indexPath.row - 1)"
            }
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

