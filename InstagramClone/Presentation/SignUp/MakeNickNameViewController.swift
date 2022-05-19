//
//  MakeNickNameViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/22.
//

import UIKit
import SnapKit

class MakeNickNameViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let nickNameTextField = UITextField()
    private let nextButton = UIButton()
    
    let name: String
    
    init(name: String) {
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

extension MakeNickNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nextButton.alpha = textField.text!.isEmpty ? 0.3 : 1.0
        nextButton.isEnabled = !textField.text!.isEmpty
    }
}

private extension MakeNickNameViewController {
    @objc func didTapLeftBarButton() {
        dismiss(animated: true)
    }
    @objc func didTapNextButton() {
        print("didTapNextButton")
        let makePasswordViewController = MakePasswordViewController(
            name: name,
            nickName: nickNameTextField.text!
        )
        navigationController?.pushViewController(makePasswordViewController, animated: true)
    }
}

private extension MakeNickNameViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .label
    }
    func attribute() {
        view.backgroundColor = .systemBackground
        
        nickNameTextField.becomeFirstResponder()
        
        titleLabel.text = "사용자 닉네임 만들기"
        titleLabel.font = .systemFont(ofSize: 32.0, weight: .medium)
        titleLabel.textAlignment = .center
        descriptionLabel.text = "새 계정에 사용할 사용자 닉네임을 선택하세요. 나중에 언제든지 변경할 수 있습니다."
        descriptionLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        nickNameTextField.placeholder = "사용자 닉네임"
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
