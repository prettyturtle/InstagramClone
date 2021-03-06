//
//  MakeNameViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/05/19.
//

import UIKit
import SnapKit

class MakeNameViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let nickNameTextField = UITextField()
    private let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension MakeNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nextButton.alpha = textField.text!.isEmpty ? 0.3 : 1.0
        nextButton.isEnabled = !textField.text!.isEmpty
    }
}

private extension MakeNameViewController {
    @objc func didTapLeftBarButton() {
        dismiss(animated: true)
    }
    @objc func didTapNextButton() {
        print("didTapNextButton")
        let makeNickNameViewController = MakeNickNameViewController(
            name: nickNameTextField.text!
        )
        navigationController?.pushViewController(makeNickNameViewController, animated: true)
    }
}

private extension MakeNameViewController {
    func setupNavigationBar() {
        let leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(didTapLeftBarButton)
        )
        leftBarButtonItem.tintColor = .label
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    func attribute() {
        view.backgroundColor = .systemBackground
        
        nickNameTextField.becomeFirstResponder()
        
        titleLabel.text = "사용자 이름 등록"
        titleLabel.font = .systemFont(ofSize: 32.0, weight: .medium)
        titleLabel.textAlignment = .center
        descriptionLabel.text = "사용자의 이름을 등록하세요. 이름은 나중에 변경할 수 없습니다."
        descriptionLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        nickNameTextField.placeholder = "사용자 이름"
        nickNameTextField.font = .systemFont(ofSize: 16.0, weight: .medium)
        nickNameTextField.borderStyle = .roundedRect
        nickNameTextField.autocapitalizationType = .none
        nickNameTextField.autocorrectionType = .no
        nickNameTextField.spellCheckingType = .no
        nickNameTextField.clearButtonMode = .whileEditing
        nickNameTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        nickNameTextField.leftViewMode = .always
        nickNameTextField.returnKeyType = .done
        nickNameTextField.delegate = self
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        nextButton.layer.cornerRadius = 4.0
        nextButton.backgroundColor = .systemBlue
        nextButton.isEnabled = false
        nextButton.alpha = 0.3
        nextButton.addTarget(
            self,
            action: #selector(didTapNextButton),
            for: .touchUpInside
        )
    }
    func layout() {
        [
            titleLabel,
            descriptionLabel,
            nickNameTextField,
            nextButton
        ].forEach { view.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(commonInset)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
        }
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(commonInset)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.height.equalTo(48.0)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(commonInset)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.height.equalTo(48.0)
        }
    }
}
