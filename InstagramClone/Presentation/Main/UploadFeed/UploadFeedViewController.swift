//
//  UploadFeedViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/07.
//

import UIKit
import SnapKit

class UploadFeedViewController: UIViewController {
    
    private let imagePickerView = UIImageView()
    private let descriptionTextView = UITextView()
    private let separatorView = UIView()
    private let optionsTableView = UITableView()
    
    private let options = [
        "사람 태그하기",
        "위치 추가"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        descriptionTextView.resignFirstResponder()
    }
}
extension UploadFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTableViewCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
}

extension UploadFeedViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.textColor = .label
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = .secondaryLabel
            textView.text = "문구 입력..."
        }
    }
}

extension UploadFeedViewController {
    @objc func didTapLeftBarButton() {
        dismiss(animated: true)
    }
    @objc func didTapRightBarButton() {
        print("didTapRightBarButton is Called!")
    }
}

private extension UploadFeedViewController {
    func attribute() {
        view.backgroundColor = .systemBackground
        
        imagePickerView.backgroundColor = .secondarySystemBackground
        descriptionTextView.font = .systemFont(ofSize: 16.0, weight: .regular)
        descriptionTextView.text = "문구 입력..."
        descriptionTextView.textColor = .secondaryLabel
        descriptionTextView.delegate = self
        
        separatorView.backgroundColor = .separator
        
        optionsTableView.dataSource = self
        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionsTableViewCell")
    }
    func layout() {
        let commonInset: CGFloat = 16.0
        
        [
            imagePickerView,
            descriptionTextView,
            separatorView,
            optionsTableView
        ].forEach { view.addSubview($0) }
        
        imagePickerView.snp.makeConstraints {
            $0.size.equalTo(100.0)
            $0.leading.equalToSuperview().inset(commonInset)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
        }
        descriptionTextView.snp.makeConstraints {
            $0.leading.equalTo(imagePickerView.snp.trailing).offset(8.0)
            $0.top.equalTo(imagePickerView.snp.top)
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.height.equalTo(imagePickerView.snp.height)
        }
        separatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(imagePickerView.snp.bottom).offset(commonInset)
            $0.height.equalTo(0.2)
        }
        optionsTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(separatorView.snp.bottom)
        }
    }
    func setupNavigationBar() {
        navigationItem.title = "새 게시물"
        let leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(didTapLeftBarButton)
        )
        let rightBarButtonItem = UIBarButtonItem(
            title: "공유",
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButton)
        )
        leftBarButtonItem.tintColor = .label
        rightBarButtonItem.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}
