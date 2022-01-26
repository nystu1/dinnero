import Firebase
import FirebaseFirestore


class FirebaseService {
    
    var database: Firestore?
    
    init(database: Firestore = Firestore.firestore()) {
        self.database = database
    }
    
    func fetchDinnerSuggestions(completion: @escaping ([RealmDinner]) -> Void) {
        database?.collection(FirebaseConstants.dinnerSuggestionsCollection()).getDocuments(completion: { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else { return }
            let dinners = documents.map{RealmDinner(snapshot: $0)}
            completion(dinners)
        })
    }
    
    func uploadNewDinnerSuggestions(){
        let collectionName = "dinnerSuggestions_da"
        
        let dinners: [String] = []
        
        for dinner in dinners {
            let realmDinner = RealmDinner()
            realmDinner.name = dinner
            database?.collection(collectionName).document(dinner).setData([
                "name": dinner,
                "url": ""
            ])
        }
        

    }
}
