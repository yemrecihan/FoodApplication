
import Foundation
import UIKit
import RxSwift
import RxCocoa
class CartPageViewModel {
    
    let items: BehaviorRelay<[CartFood]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()
    private var foodsRepository: FoodsRepository
    let totalCartPrice: BehaviorRelay<Double> = BehaviorRelay(value: 0.0)
    
    init(foodsRepository: FoodsRepository = FoodsRepository()) {
        self.foodsRepository = foodsRepository
        bindTotalPriceCalculation()
    }
    func fetchCartFoods() {
        foodsRepository.fetchCartFood()
            .subscribe(onSuccess: {[weak self] cartFoods in
                self?.items.accept(cartFoods)
            },onError: {error in
                print("Failed to fetch cart foods:\(error)")
                
            })
            .disposed(by:disposeBag)
    }
    func deleteCartFood(cartFoodID: String) {
        foodsRepository.deleteCartFood(cartFoodID: cartFoodID)
                    .subscribe(onSuccess: { [weak self] success in
                        if success {
                            self?.fetchCartFoods()
                        }
                    }, onError: { error in
                        print("Failed to delete cart food: \(error)")
                    })
                    .disposed(by: disposeBag)
            }
    private func bindTotalPriceCalculation() {
          items
              .map { foods in
                  foods.reduce(0.0) { total, food in
                      let price = Double(food.yemek_fiyat ?? "0") ?? 0.0
                      let quantity = Double(food.yemek_siparis_adet ?? "0") ?? 0.0
                      return total + (price * quantity)
                  }
              }
              .bind(to: totalCartPrice)
              .disposed(by: disposeBag)
      }
  }
        
    

