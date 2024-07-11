

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var foodNetPrice: UILabel!
    @IBOutlet weak var foodPiece: UILabel!
    
    @IBOutlet weak var foodTotalPrice: UILabel!
    
    var deleteAction:(()-> Void)?
    var updateTotalPrice: ((Double) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @IBAction func foodDelete(_ sender: Any) {
        print("Delete button clicked")
        deleteAction?()
    }
    func configure(with cartFood: CartFood) {
        let translatedFoodName = TranslationHelper.translate(cartFood.yemek_adi ?? "")
            foodName.text = translatedFoodName
        foodNetPrice.text = "\(cartFood.yemek_fiyat ?? "0")₺"
            //foodPrice.text = "\(cartFood.yemek_fiyat ?? "0") ₺"
            foodPiece.text = "Qty: \(cartFood.yemek_siparis_adet ?? "0")"
            if let imageName = cartFood.yemek_resim_adi {
                foodImage.kf.setImage(with: URL(string:"http://kasimadalan.pe.hu/yemekler/resimler/\(imageName)"))
            }
            
            if let price = Double(cartFood.yemek_fiyat ?? "0"), let quantity = Double(cartFood.yemek_siparis_adet ?? "0") {
                let total = price * quantity
                foodTotalPrice.text = String(format: "₺ %.2f", total)
                
            }else {
                foodTotalPrice.text = "₺ 0.0"
            }
        }
    
    
}
