import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class CartPage: UIViewController {
    
    var viewModel = CartPageViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var shippingCosts: UILabel!
    
    @IBOutlet weak var shippingCostsPrice: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    
    @IBOutlet weak var TotalPriceLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = UIColor.purple
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.boldSystemFont(ofSize: 24) // Bold and larger font size
                ]
        navigationController?.navigationBar.standardAppearance = appearance
              navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.title = "My Cart"
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        bindViewModel()
        viewModel.fetchCartFoods()
        
        tableView.tableFooterView = footerView
    
    }
    
    @IBAction func confirmCart(_ sender: Any) {
    }
    
    func bindViewModel() {
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: "CartCell",cellType: CartCell.self)) {row,cartFood,cell in
                
                cell.configure(with: cartFood)
                cell.deleteAction = { [weak self]  in
                self?.showDeleteConfirmation(cartFoodID: cartFood.sepet_yemek_id ?? "")
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.totalCartPrice
                .map { String(format: "₺ %.2f", $0) }
                .bind(to: TotalPriceLabel.rx.text)
                .disposed(by: disposeBag)
        
        
    }
    func showDeleteConfirmation(cartFoodID: String?) {
            guard let cartFoodID = cartFoodID else { return }
        
            print("Showing delete confirmation for food ID: \(cartFoodID)")
            
            let alert = UIAlertController(title: "Are you sure you want to delete?", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in
                print("Confirmed delete action")
                self?.viewModel.deleteCartFood(cartFoodID: cartFoodID)
            }
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            present(alert, animated: true, completion: nil)
        }
}
extension CartPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartCell
        let cartFood = viewModel.items.value[indexPath.row]
        
        cell.foodName.text = cartFood.yemek_adi
        cell.foodPrice.text = "\(cartFood.yemek_fiyat ?? "0") ₺"
        cell.foodPiece.text = "Qty: \(cartFood.yemek_siparis_adet ?? "0")"
        if let imageName = cartFood.yemek_resim_adi {
            cell.foodImage.kf.setImage(with: URL(string:"http://kasimadalan.pe.hu/yemekler/resimler/\(imageName)"))
        }
        
        return cell
    }
}
    
    

