import Foundation

class Foods : Codable {
    var yemek_id : String?
    var yemek_adi: String?
    var yemek_resim_adi: String?
    var yemek_fiyat: String?
    
    init(yemek_id: String, yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: String) {
        self.yemek_id = yemek_id
        self.yemek_adi = yemek_adi
        self.yemek_resim_adi = yemek_resim_adi
        self.yemek_fiyat = yemek_fiyat
    }
    
  
}







/*init(foodId: String, foodName: String, foodImageName: String, foodPrice: String) {
    self.foodId = foodId
    self.foodName = foodName
    self.foodImageName = foodImageName
    self.foodPrice = foodPrice
}*/
