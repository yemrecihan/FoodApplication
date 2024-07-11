import Foundation
import Alamofire
import RxSwift

class FoodsRepository {
    func fetchFoods() -> Single<[Foods]> {
        return Single.create { single in
            AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
                if let data = response.data {
                    do {
                        let response = try JSONDecoder().decode(FoodsResponse.self, from: data)
                        if let foods = response.yemekler {
                            single(.success(foods))
                        } else {
                            single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                        }
                    } catch {
                        single(.failure(error))
                    }
                } else if let error = response.error {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchCartFood() ->Single<[CartFood]> {
        return Single.create {single in
            AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php",method: .post,parameters: ["kullanici_adi":"emre_cihan"]).response {response in
                if let data = response.data {
                    do{
                        let responseString = String(data:data,encoding: .utf8)
                        print ("Response data: \(responseString ?? "No data")")
                        let response = try? JSONDecoder().decode(CartResponse.self, from: data)
                        if let foods = response?.sepet_yemekler{
                            single(.success(foods))
                        }else{
                            single(.failure(NSError(domain: "", code: -1,userInfo: [NSLocalizedDescriptionKey:"No Data"])))
                            
                        }
                        
                    }catch{
                        single(.failure(error))
                    }
                }else if let error = response.error{
                    single(.failure(error))
                }
                
            }
            return Disposables.create()
        }
        
    }
    func AddToCartButton (food:Foods, quantity: Int) ->Single<AddToCartFood>{
        let parameters:[String: Any] = [
            "yemek_adi": food.yemek_adi ?? "ss",
            "yemek_resim_adi":food.yemek_resim_adi ?? "ss",
            "yemek_fiyat":food.yemek_fiyat ?? "1",
            "yemek_siparis_adet":quantity,
            "kullanici_adi":"emre_cihan"
        ]
        return Single.create {single in
            AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php",method: .post,parameters: parameters).response {response in
                if let data = response.data {
                    do{
                        let addResponse = try? JSONDecoder().decode(AddToCartFood.self, from: data)
                        if let addResponse = addResponse{
                            single(.success(addResponse))
                        }else {
                            single(.failure(NSError(domain: "", code: -1,userInfo: [NSLocalizedDescriptionKey:"No Data"])))
                        }
                        
                        
                    }catch{
                        single(.failure(error))
                    }
                }else if let error = response.error{
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteCartFood(cartFoodID:String)->Single<Bool>{
        return Single.create {single in
            let parameters: [String:Any] = [
                "sepet_yemek_id":cartFoodID,
                "kullanici_adi":"emre_cihan"
            ]
            AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post, parameters: parameters).response {response in
                if response.error != nil {
                    single(.failure(response.error!))
                }else {
                    single(.success(true))
                }
            }
            return Disposables.create()
            
        }
        
    }
    
}
