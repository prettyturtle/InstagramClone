//
//  SignInViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/20.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    private let idTextField = UITextField()
    private let pwTextField = UITextField()
    private let signInButton = UIButton()
    private let signUpLabel = UILabel()
    private let moveToSignUpButton = UIButton()
    private let signUpStackView = UIStackView()
    
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

private extension SignInViewController {
    @objc func didTapLeftBarButton() {
        dismiss(animated: true)
    }
    @objc func didTapSignInButton() {
        print("didTapSignInButton")
    }
    @objc func didTapMoveToSignUpButton() {
        print("didTapMoveToSignUpButton")
        let rootVC = MakeNickNameViewController()
        let signUpVC = UINavigationController(rootViewController: rootVC)
        signUpVC.modalPresentationStyle = .fullScreen
        self.present(signUpVC, animated: true)
    }
}

private extension SignInViewController {
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
        
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.tintColor = .label
        
        [idTextField, pwTextField].forEach {
            $0.font = .systemFont(ofSize: 16.0, weight: .medium)
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.borderStyle = .roundedRect
            $0.clearButtonMode = .whileEditing
        }
        idTextField.placeholder = "이메일"
        idTextField.keyboardType = .emailAddress
        pwTextField.placeholder = "비밀번호"
        pwTextField.isSecureTextEntry = true
        
        signInButton.setTitle("로그인", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = .systemBlue
        signInButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        signInButton.layer.cornerRadius = 4.0
        signInButton.addTarget(
            self,
            action: #selector(didTapSignInButton),
            for: .touchUpInside
        )
        
        signUpLabel.text = "계정이 없으신가요?"
        signUpLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        signUpLabel.textColor = .secondaryLabel
        
        moveToSignUpButton.setTitle("가입하기", for: .normal)
        moveToSignUpButton.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .semibold)
        moveToSignUpButton.setTitleColor(.systemBlue, for: .normal)
        moveToSignUpButton.addTarget(
            self,
            action: #selector(didTapMoveToSignUpButton),
            for: .touchUpInside
        )
        
        signUpStackView.spacing = 4.0
    }
    func layout() {
        [
            signUpLabel,
            moveToSignUpButton
        ].forEach { signUpStackView.addArrangedSubview($0) }
        
        [
            logoImageView,
            idTextField,
            pwTextField,
            signInButton,
            signUpStackView
        ].forEach { view.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(commonInset * 2)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(48.0)
        }
        idTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(logoImageView.snp.bottom).offset(commonInset)
            $0.height.equalTo(48.0)
        }
        pwTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(idTextField.snp.bottom).offset(commonInset / 2)
            $0.height.equalTo(48.0)
        }
        signInButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(pwTextField.snp.bottom).offset(commonInset)
            $0.height.equalTo(48.0)
        }
        signUpStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
