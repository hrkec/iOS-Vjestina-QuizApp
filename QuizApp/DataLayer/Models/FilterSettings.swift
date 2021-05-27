struct FilterSettings {

    let searchText: String?
//    let price: String?

    init(searchText: String? = nil) {
        self.searchText = (searchText?.isEmpty ?? true) ? nil : searchText
//        self.price = price == "ALL" ? nil : price
    }

}
