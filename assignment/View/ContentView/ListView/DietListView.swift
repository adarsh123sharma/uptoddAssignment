//
//  DietListView.swift
//  assignment
//
//  Created by Adarsh Sharma on 25/12/24.
//

import SwiftUI
import UIKit

struct DietListView: UIViewControllerRepresentable {
    var diets: [AllDiets]
    
    // Coordinator to manage data source and delegate
    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var parent: DietListView
        
        init(parent: DietListView) {
            self.parent = parent
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            print("Dequeuing cell for section \(parent.diets.count)")
            return parent.diets.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("Dequeuing cell for row \(parent.diets[section].recipes?.count ?? 0)")
            return parent.diets[section].recipes?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("Dequeuing cell for section: \(indexPath.section), row: \(indexPath.row)")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DietTableViewCell.identifier, for: indexPath) as? DietTableViewCell else {
                print("Failed to dequeue DietTableViewCell")
                return UITableViewCell()
            }
            if let recipe = parent.diets[indexPath.section].recipes?[indexPath.row] {
                print("Configuring cell with recipe: \(recipe.title ?? "N/A")")
                cell.configure(with: recipe)
            }
            return cell
        }

        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return parent.diets[section].daytime
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerLabel = UILabel()
            headerLabel.text = parent.diets[section].daytime
            headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
            headerLabel.textColor = .systemBlue
            headerLabel.textAlignment = .left
            headerLabel.backgroundColor = .clear
            return headerLabel
        }
        
    }
    
    // Create UITableViewController
    func makeUIViewController(context: Context) -> UITableViewController {
        let tableViewController = UITableViewController(style: .insetGrouped)
        
        let nib = UINib(nibName: DietTableViewCell.identifier, bundle: nil)
        tableViewController.tableView.register(nib, forCellReuseIdentifier: DietTableViewCell.identifier)
        
        tableViewController.tableView.dataSource = context.coordinator
        tableViewController.tableView.delegate = context.coordinator
        return tableViewController
    }
    
    // Update UITableViewController when data changes
    func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
        uiViewController.tableView.reloadData()
    }
    
    // Create the Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
