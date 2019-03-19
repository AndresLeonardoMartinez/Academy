import UIKit

class comicsViewController: UIViewController {
    
    @IBOutlet weak var myCollection : UICollectionView!
    @IBOutlet weak var noConnectionLabel : UILabel!

    var comics : [Comic]?
    @IBOutlet weak var isLoading : UIActivityIndicatorView!
    var networking : Networking?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading.hidesWhenStopped = true
        isLoading.startAnimating()
        comics = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.noConnectionLabel.isHidden = Connectivity.isConnectedToInternet()
        self.networking = Networking(context: context)
        self.networking?.getElements(url: "comics", toParse: ResponseComic.self, limit:100, completion: {
            response in
            self.comics?.append(contentsOf: response.data.results.filter({ (Comic) -> Bool in
                    // filter to eliminate elements tha hasn't image
                    
                let image = Comic.thumbnail.path
                    return !image.contains("image_not_available")
            }))
            self.myCollection.reloadData()
            self.isLoading.stopAnimating()
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destineViewController = segue.destination as? DetailsViewController
        guard let miSender = sender as? UICollectionViewCell else{return}
        guard let index = myCollection.indexPath(for: miSender)?.row else {return}
        let miComic = comics?[index]
        let detail = Detail(name: miComic?.title, description: miComic?.descriptionComic, image: miComic?.thumbnail)
        destineViewController?.detail = detail
        
    }

  
  
}

extension comicsViewController: UITableViewDelegate{
    
}
extension comicsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = myCollection.dequeueReusableCell(withReuseIdentifier:  "reusedCollectionCell", for: indexPath) as! ImageCollectionViewCell
        if let imageURL = comics?[indexPath.row].thumbnail{
            let url = URL(string: imageURL.path + "." + imageURL.thumbnailExtension)
            myCell.image.sd_setImage(with:  url, placeholderImage: nil, options: [], completed: nil)
        }
        
        return myCell
    }
    
   
    

}
