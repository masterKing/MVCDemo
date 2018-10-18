//
//  TableViewController.swift
//  MVC
//
//  Created by Franky on 2018/10/18.
//  Copyright © 2018 Franky. All rights reserved.
//

import UIKit


// 定义简单的 ToDo Model
struct ToDoItem {
    let id: UUID
    let title: String
    
    init(title: String) {
        self.id = UUID()
        self.title = title
    }
}

extension ToDoItem: Equatable {
    public static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        return lhs.id == rhs.id
    }
}

class TableViewController: UITableViewController {
    var items: [ToDoItem] = []
    
    @IBOutlet weak var addButon: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.tableFooterView = UIView(frame: CGRect())
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        let newCount = items.count + 1
        let title = "ToDo Item \(newCount)"
        
        // 更新 'items'
        items.append(.init(title: title))
        
        // 为 tableView 添加新行
        let indexPath = IndexPath(row: newCount - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // 确定是否达到列表上限,如果达到,禁用 addButton
        if newCount >= 10 {
            addButon.isEnabled = false
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = items[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, done) in
            // 用户确认删除,从 'items' 中移除改事项
            self.items.remove(at: indexPath.row)
            // 从tableView中移除对应的行
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            // 维护 addButton 状态
            if self.items.count < 10 {
                self.addButon.isEnabled = true
            }
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
