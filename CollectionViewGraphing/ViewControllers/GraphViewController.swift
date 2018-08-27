//
//  GraphViewController.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 7/8/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    // MARK: Public Properties
    @IBOutlet var previousCityButton: UIButton! {
        didSet {
            configure(previousCityButton, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        }
    }
    @IBOutlet var nextCityButton: UIButton! {
        didSet {
            configure(nextCityButton, maskedCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        }
    }
    @IBOutlet var cityLabel: UILabel! {
        didSet {
            configure(cityLabel)
        }
    }
    
    @IBOutlet var previousYearButton: UIButton! {
        didSet {
            configure(previousYearButton, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        }
    }
    @IBOutlet var nextYearButton: UIButton! {
        didSet {
            configure(nextYearButton, maskedCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        }
    }
    
    @IBOutlet var yearLabel: UILabel! {
        didSet {
            configure(yearLabel)
        }
    }
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            updateLayout()
            
            collectionView.register(UINib(nibName: GraphLabelCollectionReusableView.nibName, bundle: nil),
                                    forSupplementaryViewOfKind: CollectionViewGraphLayout.labelKind,
                                    withReuseIdentifier: GraphLabelCollectionReusableView.reuseIdentifier)
            collectionView.register(UINib(nibName: TemperatureCollectionViewCell.nibName, bundle: nil),
                                    forCellWithReuseIdentifier: TemperatureCollectionViewCell.reuseIdentifier)
        }
    }
    
    // MARK: Private Properties
    private var layoutType: GraphLayoutType = .circle
    private let cityTemperatureDataSource = CityTemperatureDataSource()
    
    private lazy var circleLayout: CollectionViewCircleGraphLayout = {
        let layout = CollectionViewCircleGraphLayout()
        layout.delegate = self
        layout.register(HeatMapDecorationView.self, forDecorationViewOfKind: CollectionViewCircleGraphLayout.graphKind)
        return layout
    }()
    
    private lazy var lineLayout: CollectionViewLineGraphLayout = {
        let layout = CollectionViewLineGraphLayout()
        layout.delegate = self
        layout.register(HeatMapDecorationView.self, forDecorationViewOfKind: CollectionViewLineGraphLayout.graphKind)
        return layout
    }()
    
    // MARK: Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTemperatureDataSource.configure(with: "Denver", year: 2017)
        updatePickers()
    }
    
    // MARK: Private Methods
    private func updateLayout() {
        collectionView.setCollectionViewLayout(layoutType == .circle ? circleLayout : lineLayout, animated: true)
    }
    
    private func updatePickers() {
        cityLabel.text = cityTemperatureDataSource.city?.name
        yearLabel.text = "\(cityTemperatureDataSource.year ?? "")"
        previousCityButton.isEnabled = cityTemperatureDataSource.hasPreviousCity
        nextCityButton.isEnabled = cityTemperatureDataSource.hasNextCity
        previousYearButton.isEnabled = cityTemperatureDataSource.hasPreviousYear
        nextYearButton.isEnabled = cityTemperatureDataSource.hasNextYear
    }
    
    private func configure(_ button: UIButton, maskedCorners: CACornerMask) {
        button.layer.borderColor = UIColor.midnightBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.layer.maskedCorners = maskedCorners
        button.tintColor = .midnightBlue
    }
    
    private func configure(_ label: UILabel) {
        label.layer.borderColor = UIColor.midnightBlue.cgColor
        label.layer.borderWidth = 1
        label.textColor = .midnightBlue
    }
    
    private func reloadData() {
        collectionView.reloadSections(IndexSet(integer: 0))
        updatePickers()
    }
}

// MARK: - Collection View DataSource Methods
extension GraphViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityTemperatureDataSource.temps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TemperatureCollectionViewCell.reuseIdentifier, for: indexPath) as? TemperatureCollectionViewCell,
            let temp = cityTemperatureDataSource.temp(at: indexPath) {
            cell.configure(with: temp)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == CollectionViewCircleGraphLayout.labelKind,
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GraphLabelCollectionReusableView.reuseIdentifier, for: indexPath) as? GraphLabelCollectionReusableView else {
            return UICollectionReusableView()
        }

        view.configureWithText(cityTemperatureDataSource.sections[indexPath.item])
        
        return view
    }
}

// MARK: - Graph Layout Delegate Methods
extension GraphViewController: CollectionViewDelegateGraphLayout {
    // MARK: Item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    // MARK: Labels (Supplementary Views)
    func numberOfLabels(in collectionView: UICollectionView) -> Int {
        return cityTemperatureDataSource.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForLabelAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    // MARK: Graph (Decoration View)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForDecorationViewAt indexPath: IndexPath) -> CGSize {
        switch layoutType {
        case .circle:
            let shortestSide = CGFloat.minimum(collectionView.bounds.height, collectionView.bounds.width) - 130
            return CGSize(width: shortestSide, height: shortestSide)
        case .line:
            return CGSize(width: collectionView.bounds.width - 100, height: collectionView.bounds.height - 100)
        }
    }
}

// MARK: - Circle Graph Layout Delegate Methods
extension GraphViewController: CollectionViewDelegateCircleGraphLayout {
    
    // MARK: Item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, angleForItemAt indexPath: IndexPath) -> Measurement<UnitAngle> {
        var month: Double = 1
        if let temp = cityTemperatureDataSource.temp(at: indexPath) {
            month = Double(temp.month)
        }
        let angleDivision = 360.0 / 12.0
        return Measurement(value: angleDivision * (month - 1), unit: UnitAngle.degrees)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, radiusPercentageForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let temp = cityTemperatureDataSource.temp(at: indexPath) else {
            return 0
        }
        
        // We are assuming that the lowest temp would be -30 and the highest temp would be 120
        let start: CGFloat = 0.2
        let stride: CGFloat = 150
        let tempValue = temp.temp + 30
        
        let fullValue = ((tempValue / stride) * 0.8) + start
        return fullValue
    }
    
    func collectionViewShouldFanClusters(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> Bool {
        return false
    }
    
    func collectionViewShouldAdjustZIndexForFannedClusters(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> Bool {
        return true
    }
    
    // MARK: Labels (Supplementary Views)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, angleForLabelAt indexPath: IndexPath) -> Measurement<UnitAngle> {
        return Measurement(value: (360.0 / Double(cityTemperatureDataSource.sections.count)) * Double(indexPath.item), unit: UnitAngle.degrees)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, radiusPercentageForLabelAt indexPath: IndexPath) -> CGFloat {
        return 1.1
    }
}

// MARK: - Line Graph Layout Methods
extension GraphViewController: CollectionViewDelegateLineGraphLayout {
    // MARK: Item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, spacingIndexForItemAt indexPath: IndexPath) -> Int {
        return indexPath.item / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, percentageValueForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let temp = cityTemperatureDataSource.temp(at: indexPath) else {
            return 0
        }
        
        // We are assuming that the lowest temp would be -30 and the highest temp would be 120
        let stride: CGFloat = 150
        let tempValue = temp.temp + 30
        
        let fullValue = tempValue / stride
        return fullValue
    }
}

// MARK: - Actions
extension GraphViewController {
    @IBAction func nextCityTapped() {
        if cityTemperatureDataSource.nextCity() {
            reloadData()
        }
    }
    
    @IBAction func previousCityTapped() {
        if cityTemperatureDataSource.previousCity() {
            reloadData()
        }
    }
    
    @IBAction func nextYearTapped() {
        if cityTemperatureDataSource.nextYear() {
            reloadData()
        }
    }
    
    @IBAction func previousYearTapped() {
        if cityTemperatureDataSource.previousYear() {
            reloadData()
        }
    }
    
    @IBAction func changeLayout() {
        if layoutType == .circle {
            layoutType = .line
        } else {
            layoutType = .circle
        }
        
        updateLayout()
    }
}
