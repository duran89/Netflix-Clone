//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by 권정근 on 2/27/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // 섹션 타이틀 배열 설정
    let sectionTitles: [String] = ["Trending Movies", "Popular", "Trending TV", "Upcoming Movies", "Top rated"]


    // MARK: -테이블 설정
    private let homeFeedTable: UITableView = {
        // table의 스타일 확인
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        // 네비게이션 바 설정 함수 호출
        configureNavbar()
        
        // 테이블 뷰의 헤드 부분 사이즈(크기) 설정
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        // API Call
        getTrendingMovies()
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "logo")
        
        // 이 아래를 설정하기 전에는 로고 이미지가 파란색으로 꺠져서 나온다.
        // withRenderingMode 란?
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    
    // viewDidLayoutSubview?
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    
    private func getTrendingMovies() {
        APICaller.shared.getTrendingMovies { results in
            switch results {
            case .success(let movies):
                print(movies)
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 아래 numberOfRowsInseciton과의 차이 확인해볼 것 
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    // 테이블 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // 테이블 헤더 부분의 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    // 테이블 섹션 헤더에 들어가 있는 텍스트의 크기 및 글꼴 세팅
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 10, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        /*
         아래 코드를 작성하기 전에는 테이블 섹션 헤더에 들어가는 타이틀이 대문자로 나온다.
         */
        header.textLabel?.text = header.textLabel?.text?.lowercased()
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    /*
     현재는 화면을 내리면 위에 네비게이션 부분이 화면 상단에 나타나지만,
     아래 코드를 통해 네비게이션 부분이 딸려오는 것을 막는다.
     */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
