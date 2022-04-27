//
//  MakeEmailViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/26.
//

import UIKit
import SnapKit

class MakeEmailViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let emailTextField = UITextField()
    private let nextButton = UIButton()
    
    let password: String
    let nickName: String
    private let firebaseAuthManager = FirebaseAuthManager()
    
    init(nickName: String, password: String) {
        self.nickName = nickName
        self.password = password
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

extension MakeEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nextButton.alpha = textField.text!.isEmpty ? 0.3 : 1.0
        nextButton.isEnabled = !textField.text!.isEmpty
    }
}

private extension MakeEmailViewController {
    @objc func didTapLeftBarButton() {
        dismiss(animated: true)
    }
    @objc func didTapNextButton() {
        print("didTapNextButton")
        firebaseAuthManager.signUp(
            email: emailTextField.text!,
            password: password,
            nickName: nickName) { [weak self] result in
                switch result {
                case .success(_):
                    let alertController = UIAlertController(
                        title: "회원가입 성공",
                        message: nil,
                        preferredStyle: .alert
                    )
                    let okAction = UIAlertAction(
                        title: "OK",
                        style: .default
                    ) { [weak self] _ in
                        self?.dismiss(animated: true)
                    }
                    alertController.addAction(okAction)
                    self?.present(alertController, animated: true)
                case .failure(let error):
                    let alertController = UIAlertController(
                        title: "회원가입 실패",
                        message: "\(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    let okAction = UIAlertAction(title: "OK", style: .destructive)
                    alertController.addAction(okAction)
                    self?.present(alertController, animated: true)
                }
            }
    }
}

private extension MakeEmailViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    func attribute() {
        view.backgroundColor = .systemBackground
        
        emailTextField.becomeFirstResponder()
        
        titleLabel.text = "이메일 만들기"
        titleLabel.font = .systemFont(ofSize: 32.0, weight: .medium)
        titleLabel.textAlignment = .center
        descriptionLabel.text = "새 계정에 사용할 이메일을 입력하세요. 이메일은 나중에 변경할 수 없습니다."
        descriptionLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        emailTextField.placeholder = "이메일"
        emailTextField.font = .systemFont(ofSize: 16.0, weight: .medium)
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.spellCheckingType = .no
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        emailTextField.leftViewMode = .always
        emailTextField.returnKeyType = .done
        emailTextField.keyboardType = .emailAddress
        emailTextField.delegate = self
        
        nextButton.setTitle("회원가입하기", for: .normal)
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
            emailTextField,
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
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(commonInset)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.height.equalTo(48.0)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(commonInset)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.height.equalTo(48.0)
        }
    }
}
