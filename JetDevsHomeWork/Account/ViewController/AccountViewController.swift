//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import Kingfisher
import RxSwift

class AccountViewController: BaseViewController {
    
    typealias ViewModel = AnyViewModel<AccountViewModel.State, AccountViewModel.Event>
    
    @IBOutlet weak var nonLoginView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    
    private let viewModel: ViewModel
    
    // MARK: - Initialization
    
    init(viewModel: ViewModel = AnyViewModel(AccountViewModel())) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        nonLoginView.isHidden = false
        loginView.isHidden = true
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onReceiveEvent(.viewWillAppear)
    }
    
    // MARK: - Private Methods
    private func bindViewModel() {
        
        viewModel.state
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: {(viewController, state) in
                
                switch state {
                case .showLoginScreen:
                    LoginViewController.show(in: viewController)
                case .showProfileDetail(let user):
                    viewController.setProfileData(user)
                    
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.onReceiveEvent(.viewLoaded)
    }
    
    private func setProfileData(_ user: UserResponse) {
       loginView.isHidden = false
        if let userData = user.data?.user {
            nameLabel.text = userData.userName
            if let profileURL = URL(string: userData.userProfileUrl ?? "") {
                setProfileImage(url: profileURL)
            }
            
            if let date = userData.createdAt, let timeAgo = date.toDate(format: .utc)?.timeAgoDisplay() {
                daysLabel.text = "Created \(timeAgo)"
            }
        }
    }
    
    private func setProfileImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: headImageView.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 0)
        headImageView.kf.indicatorType = .activity
        headImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Avatar"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ], completionHandler: {[weak self] result in
                switch result {
                case .success:
                    self?.headImageView.layer.cornerRadius = (self?.headImageView.frame.height ?? 0) / 2
                case .failure: break
                }
            })
    }
    // MARK: - @IBAction Methods
	@IBAction func loginButtonTap(_ sender: UIButton) {
        viewModel.onReceiveEvent(.loginButtonTapped)
	}
	
}
