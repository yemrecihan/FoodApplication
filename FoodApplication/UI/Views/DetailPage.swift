

import RxSwift
import RxCocoa
import UIKit

class DetailPage : UIViewController {
    
    var viewModel: DetailPageViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var labelFoodDetail: UILabel!
    
    @IBOutlet weak var foodImage: UIImageView!
    
    @IBOutlet weak var labelFoodPrice: UILabel!
    
    @IBOutlet weak var labelFoodName: UILabel!
    
    @IBOutlet weak var labelPiece: UILabel!
    
    @IBOutlet weak var labelMin: UILabel!
    
    @IBOutlet weak var labelDelivery: UILabel!
    
    @IBOutlet weak var labelSale: UILabel!
    
    @IBOutlet weak var labelTotalPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel == nil {
            print("Error: viewModel is nil")
            return
        }
        
        bindViewModel()
    }
    private func bindViewModel() {
            viewModel.food
                .subscribe(onNext: { [weak self] food in
                    guard let food = food else { return }
                    self?.labelFoodName.text = food.yemek_adi
                    self?.labelFoodPrice.text = "₺ \(food.yemek_fiyat ?? "0")"
                    if let imageName = food.yemek_resim_adi {
                        self?.foodImage.kf.setImage(with: URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(imageName)"))
                    }
                })
                .disposed(by: disposeBag)
        viewModel.quantity
            .map{"\($0)"}
            .bind(to: labelPiece.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .bind(to: labelTotalPrice.rx.text)
            .disposed(by: disposeBag)
        
        }

    
    
    
    @IBAction func buttonPlus(_ sender: Any) {
        viewModel.increaseQuantity()
    }
    @IBAction func buttonMinus(_ sender: Any) {
        viewModel.decreaseQuantitiy()
    }
    
    @IBAction func buttonAddToCart(_ sender: Any) {
        viewModel.addTocart()
    }
    private func showAlert(title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    
    
    
    
    
}
