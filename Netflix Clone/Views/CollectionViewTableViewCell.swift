//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by 권정근 on 2/27/24.
//

import UIKit


// 프로토콜 생성 (TitlePreview 관련)
// collectionView cell 내를 눌렀을 때 사용할 함수를 프로토콜 채택을 통해 설계
protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCelldidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}


class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = [Title]()
    
    // 테이블 셀에 들어갈 컬렉션뷰 설정
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // 셀에 들어가는 collectionView의 아이템 사이즈 설정
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // TitleCollectionViewCell 입력
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemMint
        contentView.addSubview(collectionView)
        
        // contentView란?
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
        
    }
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        // 왜??
        /*
         먼저 홈뷰컨트롤러에서 데이터를 받아오는데, 이거는 홈뷰컨트롤러 안의 테이블에 들어가는
         컬렉션뷰 셀이라는 파일 내에 함수이다. 이 함수를 통해 각 행마다의 데이터를 받아오는데,
         그럼 이걸 처리하는데 이미지를 받으니까 당연히 동시성 코드를 넣어야 한다.
         */
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        guard let model = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        
        cell.configure(with: model)
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case.success(let videoElement):
                
                let title = self?.titles[indexPath.row]
                
                guard let titleOverview = title?.overview else { return }
                
                // 옵셔널을 풀기 위한 바인딩으로 strongSelf 라고 붙임 
                guard let strongSelf = self else { return }
                
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.collectionViewTableViewCelldidTapCell(strongSelf, viewModel: viewModel)
                        
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
