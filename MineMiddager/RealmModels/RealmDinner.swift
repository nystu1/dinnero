import Foundation
import RealmSwift
import FirebaseFirestore

class RealmDinner: Object, Decodable {
    @objc dynamic var name: String?
    @objc dynamic var url: String?
        
    convenience init(name: String, url: String? = nil) {
        self.init()
        self.name = name
        self.url = url
    }
    
    convenience init(snapshot: QueryDocumentSnapshot){
        self.init()
        let snapshotValue = snapshot.data()
        self.name = snapshotValue["name"] as? String
        self.url = snapshotValue["url"] as? String
    }
}
