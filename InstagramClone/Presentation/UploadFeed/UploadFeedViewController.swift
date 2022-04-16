//
//  UploadFeedViewController.swift
//  InstagramClone
//
//  Created by yc on 2022/04/07.
//

import UIKit
import PhotosUI
import SnapKit
import Toast

class UploadFeedViewController: UIViewController {
    
    private let firebaseDBManager = FirebaseDBManager()
    
    private let imagePickerView = UIImageView()
    private let imagePickerButton = UIButton()
    private let numberOfSelectedImageLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let separatorView = UIView()
    private let optionsTableView = UITableView()
    private let activityIndicatorView = UIActivityIndicatorView()
    
    private var selectedImages = [UIImage]()
    private let options = [
        "사람 태그하기",
        "위치 추가"
    ]
    
    weak var delegate: UploadFeedViewDelegate?
    
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

extension UploadFeedViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if !results.isEmpty {
            selectedImages = []
            results.forEach { result in
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        guard let self = self else { return }
                        if let image = image as? UIImage {
                            self.selectedImages.append(image)
                            DispatchQueue.main.async {
                                self.imagePickerView.image = image
                                self.numberOfSelectedImageLabel.text = "\(self.selectedImages.count)"
                            }
                        }
                        if let error = error {
                            print("ERROR - UploadFeedViewController - PHPickerViewControllerDelegate - \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        dismiss(animated: true)
    }
}

extension UploadFeedViewController {
    @objc func didTapLeftBarButton() {
        dismiss(animated: true)
    }
    @objc func didTapRightBarButton() {
        print("didTapRightBarButton is Called!")
        
        activityIndicatorView.startAnimating()
        
        view.isUserInteractionEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let uploadFeed = UploadFeed(
            user: [User.mockUser, User.mockUser2, User.mockUser3].randomElement()!,
            location: "인하대역 스타벅스",
            images: selectedImages,
            description: descriptionTextView.textColor == .secondaryLabel ? "" : descriptionTextView.text ?? ""
        )
        
        firebaseDBManager.createFeed(
            uploadFeed: uploadFeed) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    self.activityIndicatorView.stopAnimating()
                    self.dismiss(animated: true)
                    self.delegate?.didEndUploadFeed()
                case .failure(let error):
                    print("ERROR: UploadFeedViewController - didTapRightBarButton - createFeed - \(error.localizedDescription)")
                    self.activityIndicatorView.stopAnimating()
                    self.view.makeToast("ERROR!!")
                    
                    self.view.isUserInteractionEnabled = true
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
    }
    @objc func didTapImagePickerButton() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selection = .ordered
        config.selectionLimit = 5
        let imagePickerViewController = PHPickerViewController(configuration: config)
        imagePickerViewController.delegate = self
        present(imagePickerViewController, animated: true)
    }
}

private extension UploadFeedViewController {
    func attribute() {
        view.backgroundColor = .systemBackground
        
        imagePickerView.backgroundColor = .secondarySystemBackground
        imagePickerButton.addTarget(
            self,
            action: #selector(didTapImagePickerButton),
            for: .touchUpInside
        )
        numberOfSelectedImageLabel.text = "\(selectedImages.count)"
        numberOfSelectedImageLabel.font = .systemFont(ofSize: 16.0, weight: .semibold)
        numberOfSelectedImageLabel.textColor = .white
        numberOfSelectedImageLabel.textAlignment = .center
        numberOfSelectedImageLabel.backgroundColor = .systemBlue
        numberOfSelectedImageLabel.clipsToBounds = true
        numberOfSelectedImageLabel.layer.cornerRadius = 12.0
        
        descriptionTextView.font = .systemFont(ofSize: 16.0, weight: .regular)
        descriptionTextView.text = "문구 입력..."
        descriptionTextView.textColor = .secondaryLabel
        descriptionTextView.delegate = self
        
        separatorView.backgroundColor = .separator
        
        optionsTableView.dataSource = self
        optionsTableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "OptionsTableViewCell"
        )
    }
    func layout() {
        let commonInset: CGFloat = 16.0
        
        [
            imagePickerView,
            imagePickerButton,
            numberOfSelectedImageLabel,
            descriptionTextView,
            separatorView,
            optionsTableView,
            activityIndicatorView
        ].forEach { view.addSubview($0) }
        
        imagePickerView.snp.makeConstraints {
            $0.size.equalTo(100.0)
            $0.leading.equalToSuperview().inset(commonInset)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
        }
        
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        imagePickerButton.widthAnchor.constraint(
            equalTo: imagePickerView.widthAnchor
        ).isActive = true
        imagePickerButton.heightAnchor.constraint(
            equalTo: imagePickerView.heightAnchor
        ).isActive = true
        imagePickerButton.centerXAnchor.constraint(
            equalTo: imagePickerView.centerXAnchor
        ).isActive = true
        imagePickerButton.centerYAnchor.constraint(
            equalTo: imagePickerView.centerYAnchor
        ).isActive = true
        
        numberOfSelectedImageLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfSelectedImageLabel.widthAnchor.constraint(
            equalToConstant: 24.0
        ).isActive = true
        numberOfSelectedImageLabel.heightAnchor.constraint(
            equalToConstant: 24.0
        ).isActive = true
        numberOfSelectedImageLabel.topAnchor.constraint(
            equalTo: imagePickerView.topAnchor,
            constant: -8.0
        ).isActive = true
        numberOfSelectedImageLabel.trailingAnchor.constraint(
            equalTo: imagePickerView.trailingAnchor,
            constant: 8.0
        ).isActive = true
        
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
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
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
