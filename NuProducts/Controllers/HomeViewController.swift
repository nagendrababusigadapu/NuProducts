//
//  ViewController.swift
//  NuProducts
//
//  Created by Nagendra Babu on 12/02/23.
//

import UIKit
import CoreData
import Lottie

class HomeViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private let cellIdentifier = "ProductTableViewCell"
    private let viewModel = ProductsViewModel()
    private var productsList:ProductList? = nil
    private var loadDataFromLocal:Bool = false
    private var lottieAnimation: LottieAnimationView?
    
    lazy var dataProvider:ProductListProvider  = {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let provider = ProductListProvider(with: managedContext, fetchedResultsControllerDelegate: self)
        return provider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Setup UI
    
    private func setupUI(){
        title = "Products"
        tableView.separatorStyle = .none
        registerTableViewCells()
        callAPI()
    }
    
    private func registerTableViewCells(){
        let productCell = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.register(productCell, forCellReuseIdentifier: cellIdentifier)
    }

}

extension HomeViewController {
    
    //MARK: - Call API
    
    func callAPI(){
        if Connectivity.isConnectedToInternet{
            loadDataFromLocal = false
            fetchFromAPI()
        }else{
            if dataProvider.fetchedResultsController.sections?.count ?? 0 > 0 {
                loadDataFromLocal = true
                tableView.reloadData()
            }else{
                self.showAlert(withMsg: Constants.networkNotAvailableMessage)
            }
        }
    }
    
    private func fetchFromAPI(){
        showLoader(status: true)
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.viewModel.fetchData { isSuccess, error in
                self?.showLoader(status: false)
                if isSuccess{
                    self?.productsList = self?.viewModel.getResponse()
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }else{
                    self?.showAlert(withMsg: error ?? "")
                }
            }
        }
    }
}


//MARK: - UITableViewDelegate and DataSource methods
extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loadDataFromLocal{
            let sectionInfo = dataProvider.fetchedResultsController.sections?[section]
            return sectionInfo?.numberOfObjects ?? 0
        }else{
            return productsList?.products.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        if loadDataFromLocal{
            let post = dataProvider.fetchedResultsController.object(at: indexPath)
            cell.productTitle.text = post.title
            cell.productBrand.text = post.brand
            cell.productRating.text = post.rating
            cell.productPrice.text = post.price?.rupee
            
            if let data = post.thumbnailImage{
                DispatchQueue.main.async {
                    cell.thumbNailImageView.image = UIImage(data: data)
                }
            }
            
        }else{
            cell.product = productsList?.products[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension HomeViewController{
    
    private func showLoader(status:Bool){
        if status {
            lottieAnimation = LottieAnimationView(name: "loader")
            lottieAnimation?.frame = view.bounds
            lottieAnimation?.contentMode = .scaleAspectFill
            lottieAnimation?.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
            lottieAnimation?.center = self.view.center
            lottieAnimation?.isHidden = false
            view.isUserInteractionEnabled = false
            view.addSubview(lottieAnimation!)
            lottieAnimation?.loopMode = .loop
            lottieAnimation?.play()
        }else{
            view.isUserInteractionEnabled = true
            lottieAnimation?.stop()
            lottieAnimation?.isHidden = true
        }
        
    }
    
    func showAlert(withMsg msg:String){
        self.openAlert(message: msg, alertStyle: .alert, actionTitles: ["Ok"], actionStyles: [.default], actions: [{_ in}])
    }
}

