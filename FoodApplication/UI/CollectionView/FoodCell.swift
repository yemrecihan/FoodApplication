

import UIKit
import Kingfisher
import Alamofire

class FoodCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewFood: UIImageView!
    
    @IBOutlet weak var foodName: UILabel!
    
    @IBOutlet weak var imageDelivery: UIImageView!
    
    @IBOutlet weak var labelFreeDelivery: UILabel!
    
    @IBOutlet weak var foodPrice: UILabel!
    
    @IBAction func AddToCartButton(_ sender: Any) {
    }
    
   
    
    func showImage(imageName: String) {
            if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(imageName)") {
                DispatchQueue.main.async {
                    self.imageViewFood.kf.setImage(with: url)
                }
            }
        }
   
}




/*func showImage(imageName:String) {
    if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(imageName)") {
        DispatchQueue.main.async{
            self.imageViewFood.kf.setImage(with: url)
            
        }
    }
}*/
