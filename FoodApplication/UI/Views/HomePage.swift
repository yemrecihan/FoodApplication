import UIKit
import Kingfisher
import Alamofire
import RxSwift
import RxCocoa

class HomePage: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var foodsCollectionView: UICollectionView!
    var viewModel=HomePageViewModel()
    private let disposeBag = DisposeBag()
    var foods:[Foods] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
       

        
        self.navigationItem.title = "Hello"
        
        let apperance = UINavigationBarAppearance()
        apperance.backgroundColor = UIColor.purple
        apperance.titleTextAttributes = [.foregroundColor : UIColor.white , .font : UIFont(name: "Pacifico-regular", size: 22)]
        
        navigationController?.navigationBar.standardAppearance = apperance
        navigationController?.navigationBar.compactAppearance = apperance
        navigationController?.navigationBar.scrollEdgeAppearance = apperance
        
        //Add to homeıcon
        var homeIcon = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
      
        
        let homeButton = UIButton(type: .custom)
        homeButton.setImage(homeIcon, for: .normal)
        homeButton.tintColor = UIColor.white
        homeButton.frame = (CGRect(x: 0, y: 0, width: 24, height: 24))
        homeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        
        let homeBarButtonItem = UIBarButtonItem(customView: homeButton)
        navigationItem.rightBarButtonItem = homeBarButtonItem
        
        let tasarim = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 5 , left: 5, bottom: 5, right: 5)
        tasarim.minimumInteritemSpacing = 5
        tasarim.minimumLineSpacing = 5
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 15) / 2
        
        tasarim.itemSize=CGSize(width: itemGenislik, height: itemGenislik*1.6)
        
        foodsCollectionView.collectionViewLayout = tasarim
        
     /*   let layout = UICollectionViewFlowLayout()
               layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Kenar boşlukları
               layout.minimumInteritemSpacing = 10 // Hücreler arasındaki yatay boşluk
               layout.minimumLineSpacing = 10 // Hücreler arasındaki dikey boşluk
               
               let screenWidth = UIScreen.main.bounds.width
               let itemWidth = (screenWidth - 40) / 2 // Kenar boşluklarını da hesaba katarak hücre genişliği
               
               layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.6)
               foodsCollectionView.collectionViewLayout = layout
        
        foodsCollectionView.delegate = self*/
       
        
        
        viewModel = HomePageViewModel()
        bindViewModel()
        viewModel.fetchFoods()
        
        if let tabBarController = self.tabBarController {
                   tabBarController.delegate = self
               }
      
      
        
        

    
    }
    
    @objc func homeButtonTapped() {
        print("Home button clicked")
    }
   
    
    private func bindViewModel(){
       
        viewModel.filteredFoods
                   .bind(to: foodsCollectionView.rx.items(cellIdentifier: "foodCell", cellType: FoodCell.self)) { row, food, cell in
                       let translatedFoodName = TranslationHelper.translate(food.yemek_adi ?? "")
                       cell.foodName.text = translatedFoodName
                       cell.foodPrice.text = "\(food.yemek_fiyat ?? "0") ₺"
                       cell.showImage(imageName: food.yemek_resim_adi ?? "")
                       
                       cell.layer.backgroundColor = UIColor.white.cgColor
                       cell.layer.borderWidth = 0.3
                       cell.layer.cornerRadius = 10.0
    }
                   .disposed(by: disposeBag)
        searchBar.rx.text.orEmpty
               .distinctUntilChanged()
               .subscribe(onNext: { [weak self] query in
                   self?.viewModel.searchFoods(with: query)
               })
               .disposed(by: disposeBag)
        
        foodsCollectionView.rx.modelSelected(Foods.self)
            .subscribe(onNext:{[weak self] food in
                self?.viewModel.selectedFood.accept(food)
                self?.performSegue(withIdentifier: "toDetailVC", sender: nil)
            })
            .disposed(by: disposeBag)
       }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toDetailVC" {
                if let destinationVC = segue.destination as? DetailPage {
                    if let selectedFood = viewModel.selectedFood.value {
                        destinationVC.viewModel = DetailPageViewModel(food: selectedFood)
                    } else {
                        print("Error: selectedFood is nil")
                    }
                }
            } else if segue.identifier == "toCartVC" {
                if let destinationNavVC = segue.destination as? UINavigationController, let destinationVC = destinationNavVC.viewControllers.first as? CartPage {
                    // İlgili işlemler
                    destinationVC.viewModel = CartPageViewModel(foodsRepository: viewModel.foodsRepository)
                }
            }
        }

      
    
   }
extension HomePage: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is UINavigationController {
            if let navController = viewController as? UINavigationController,
               navController.topViewController is CartPage {
                performSegue(withIdentifier: "toCartVC", sender: nil)
                return false
            }
        }
        return true
    }
}

extension HomePage: UICollectionViewDelegate {
    
}

extension HomePage: UISearchBarDelegate {
    
}
    
   




