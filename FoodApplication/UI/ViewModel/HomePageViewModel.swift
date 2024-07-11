import Foundation
import RxSwift
import RxCocoa

class HomePageViewModel {
     var foodsRepository: FoodsRepository
    private let disposeBag = DisposeBag()
    
    let foods: BehaviorRelay<[Foods]> = BehaviorRelay(value: [])
    let filteredFoods: BehaviorRelay<[Foods]> = BehaviorRelay(value: [])
    let isSearching: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let selectedFood = BehaviorRelay<Foods?>(value:nil)
    
    init(foodsRepository: FoodsRepository = FoodsRepository()) {
        self.foodsRepository = foodsRepository
    }
    
    func fetchFoods() {
        foodsRepository.fetchFoods()
            .subscribe(onSuccess: { [weak self] foods in
                self?.foods.accept(foods)
                self?.filteredFoods.accept(foods)
            }, onError: { error in
                print("Failed to fetch foods: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func searchFoods(with query: String) {
        if query.isEmpty {
            isSearching.accept(false)
            filteredFoods.accept(foods.value)
        } else {
            isSearching.accept(true)
            let filtered = foods.value.filter { $0.yemek_adi?.lowercased().contains(query.lowercased()) ?? false }
            filteredFoods.accept(filtered)
        }
    }
}

