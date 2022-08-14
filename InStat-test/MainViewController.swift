//
//  MainViewController.swift
//  InStat-test
//
//  Created by Денис Рубцов on 23.05.2022.
//

import UIKit

protocol MainViewControllerDelegate {
    var mainViewControllerDelegate: MainViewController? { get set }
}

class MainViewController: UIViewController {

    deinit { print("deinit MainViewController")}
    
    var contentView: UIView!
    var cvTrailingAnchor: NSLayoutConstraint?
    var cvLeadingAnchor: NSLayoutConstraint?
    
    init(contentView: UIView) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constant.backgroundColor
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        cvLeadingAnchor = contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        cvLeadingAnchor?.isActive = true

        cvTrailingAnchor = contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        cvTrailingAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func setNavigationBarTitle(to title: String) {
        navigationItem.setTitle(with: title)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetConstraints()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        resetConstraints()
        if let tableView = contentView as? StandingsView {
            tableView.reloadData()
        }
    }

    func resetConstraints() {
        let inset = Constant.getInset()
        cvLeadingAnchor?.constant = 0
        cvTrailingAnchor?.constant = 0
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            cvLeadingAnchor?.constant = inset
            cvTrailingAnchor?.constant = 0
        case .landscapeRight:
            cvLeadingAnchor?.constant = 0
            cvTrailingAnchor?.constant = -inset
        default:
            break
        }
    }

}
