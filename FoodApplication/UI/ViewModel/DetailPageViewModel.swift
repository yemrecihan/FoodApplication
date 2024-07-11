import Foundation
import RxSwift
import RxCocoa

class DetailPageViewModel {
    let food: BehaviorRelay<Foods?>
    let quantity: BehaviorRelay<Int> = BehaviorRelay(value:1)
    let totalPrice : BehaviorRelay<String> = BehaviorRelay(value: "₺ 0.0")
    private let disposeBag = DisposeBag()
    private let foodsRepository: FoodsRepository
    
    let addToCartResult: PublishSubject<Bool>=PublishSubject()
  
    
    init(food: Foods?,foodsRepository:FoodsRepository=FoodsRepository()) {
        self.food = BehaviorRelay(value: food)
        self.foodsRepository = foodsRepository
        
        _ = self.quantity
            .withLatestFrom(self.food) { ($0,$1)}
            .subscribe(onNext: { [weak self ] (quantitiy,food) in
                self?.calculateTotalPrice(quantity: quantitiy, food: food)
            })
    }
    
    func increaseQuantity() {
        quantity.accept(quantity.value + 1)
    }
    
    func decreaseQuantitiy() {
        let newValue = max(quantity.value - 1 ,1)
        quantity.accept(newValue)
    }
    func calculateTotalPrice(quantity: Int , food: Foods?) {
        guard let food =  food , let priceString = food.yemek_fiyat, let price = Double(priceString) else {
            totalPrice.accept("₺0.0")
            return
        }
        let total = price * Double(quantity)
        totalPrice.accept(String(format:"₺ %.2f",total))
    }
    
    func addTocart(){
        guard let food = food.value else {
            addToCartResult.onNext(false)
            return
        }
        foodsRepository.AddToCartButton(food: food, quantity: quantity.value)
            .subscribe(onSuccess: {[weak self] response in
                self?.addToCartResult.onNext(true)
                
            }, onError: { [weak self] error in
                self?.addToCartResult.onNext(false)
                print("Failed to add to cart: \(error)")
                
            })
            .disposed(by: disposeBag)
    }
    
   
    
}
