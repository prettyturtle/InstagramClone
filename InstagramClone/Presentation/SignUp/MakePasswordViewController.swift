//
//  MakePasswordViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/22.
//

import UIKit
import SnapKit

class MakePasswordViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let passwordTextField = UITextField()
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

extension MakePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nextButton.alpha = textField.text!.isEmpty ? 0.3 : 1.0
        nextButton.isEnabled = !textField.text!.isEmpty
    }
}

private extension MakePasswordViewController {
    @objc func didTapLeftBarButton() {
        dismiss(animated: true)
    }
    @objc func didTapNextButton() {
        print("didTapNextButton")
    }
}

private extension MakePasswordViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .label
    }
    func attribute() {
        view.backgroundColor = .systemBackground
        
        passwordTextField.becomeFirstResponder()
        
        titleLabel.text = "비밀번호 만들기"
        titleLabel.font = .systemFont(ofSize: 32.0, weight: .medium)
        titleLabel.textAlignment = .center
        descriptionLabel.text = "비밀번호를 저장할 수 있으므로 iCloud® 기기에서 로그인 정보를 입력하지 않아도 됩니다."
        descriptionLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.font = .systemFont(ofSize: 16.0, weight: .medium)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.spellCheckingType = .no
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        passwordTextField.leftViewMode = .always
        passwordTextField.returnKeyType = .done
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
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
            passwordTextField,
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
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(commonInset)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.height.equalTo(48.0)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(commonInset)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.height.equalTo(48.0)
        }
    }
}


