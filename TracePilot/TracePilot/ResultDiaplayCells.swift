//
//  ResultDiaplayCells.swift
//  TracePilot
//
//  Created by He, Changchen on 3/8/16.
//  Copyright © 2016 VincentHe. All rights reserved.
//

import UIKit
import RealmSwift
import Charts
import ABSteppedProgressBar

class ResultDiaplayCellBasicInfo: UICollectionViewCell {
    @IBOutlet var distanceValueLabel:UILabel?
    @IBOutlet var distanceUnitLabel:UILabel?
    @IBOutlet var totalTimeLabel:UILabel?
    @IBOutlet var avgSpeed:UILabel?
    @IBOutlet var avgAltitude:UILabel?
    
    // DB store
    var traceEvent:TraceEvent?
    
    func loadCell(){
        self.contentView.backgroundColor = UIColor.whiteColor()
        if let traceEvent = self.traceEvent
        {
            let distance = traceEvent.distance
            let distanceInMiles = String(format: "%.2f", Util.distanceInMiles(distance))
            print("distance:\(distanceInMiles)")
            self.distanceValueLabel?.text = distanceInMiles
            
            let seconds = traceEvent.duration
            totalTimeLabel?.text = Util.timeString(seconds)
            
            let avgSpeedDouble = getAvgSpeed()
            avgSpeed?.text = String(format: "%.2f", avgSpeedDouble)
            
            if Util.altimeterAvailable()
            {
                let avgAlt = getAvgAltitude()
                avgAltitude?.text = String(format: "%.2f", avgAlt)
            }else
            {
                avgAltitude?.text = "-"
            }
        }
       
    }
    
    func getAvgSpeed() -> Double
    {
        let locationList = traceEvent?.traceLocations
        var validNumber = 0
        var avgSpeed:Double = 0.0
        var totalSpeed = 0.0
        for location in locationList!
        {
            if location.locationSpeed != 0
            {
                totalSpeed += location.locationSpeed
                validNumber++
            }
        }
        avgSpeed = totalSpeed / Double(validNumber)
        
        return avgSpeed
    }
    
    func getAvgAltitude() -> Double
    {
        let locationList = traceEvent?.traceLocations
        var validNumber = 0
        var avgAltitude:Double = 0.0
        var totalAlt = 0.0
        for location in locationList!
        {
            if location.locationAltitude != 0
            {
                totalAlt += location.locationAltitude
                validNumber++
            }
        }
        avgAltitude = totalAlt / Double(validNumber)
        
        return avgAltitude
    }

}

class AirportsDisplayCell:UICollectionViewCell,ABSteppedProgressBarDelegate
{
    var passedAirPorts:[(AirPort,TraceLocation)]?
    var delegate:ResultCellDelegate?

    @IBOutlet var stepperView:ABSteppedProgressBar?
    
    func loadCell()
    {
        if let airPorts = passedAirPorts
        {
            stepperView?.radius = (stepperView?.frame.height)!/4.0
            stepperView?.progressRadius = (stepperView?.frame.height)!/4.0 - 5
            stepperView?.progressLineHeight = 5
            stepperView?.numberOfPoints = airPorts.count
            stepperView?.lineHeight  = 10
            stepperView?.backgroundShapeColor = GlobalVariables.appThemeColorColor
            stepperView?.selectedBackgoundColor = UIColor.whiteColor()
            stepperView?.delegate = self
        }
        
    }
    
    func progressBar(progressBar: ABSteppedProgressBar, didSelectItemAtIndex index: Int)
    {
        self.delegate?.didTabOnAirportViewAtIndex(index)
    }
}

class ChartCellAltitudeCell:ChartCellSpeedCell{
    override var drawSpeedOrAltitude: Bool { get { return false } }
    override var descripLabelString:String { get { return "Altitude(ft)" } }
    override var lineColor:UIColor { get { return UIColor(hex: "#8e44ad") } }


}

class ChartCellSpeedCell: UICollectionViewCell,ChartViewDelegate{
    @IBOutlet var lineChartView:LineChartView?
    
    // DB store
    var traceEvent:TraceEvent?
    var dataEntries: [BarChartDataEntry] = []
    var x:[Int] = []
    var delegate:ResultCellDelegate?
    // true = speed  false = altitude
    var drawSpeedOrAltitude:Bool { get { return true } }
    var descripLabelString:String { get { return "Speed(kts)" } }
    
    var lineColor:UIColor { get { return UIColor(hex: "#E74C3C") } }
    
    func loadCell()
    {
        dataEntries.removeAll()
        x.removeAll()
        
        lineChartView?.layer.cornerRadius = 10.0
        lineChartView?.layer.borderColor = UIColor.clearColor().CGColor
        lineChartView?.layer.borderWidth = 0.5
        lineChartView?.clipsToBounds = true
        lineChartView?.delegate = self
        
        if let traceEvent = self.traceEvent
        {
            var index = 0
            for location in traceEvent.traceLocations
            {
                let dataEntry = BarChartDataEntry(value: drawSpeedOrAltitude ? location.locationSpeed : location.locationAltitude, xIndex: index)
                dataEntries.append(dataEntry)
                x.append(index)
                index++
            }
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: descripLabelString)
        chartDataSet.lineWidth = 2
        chartDataSet.fillColor = UIColor.whiteColor()//ChartColorTemplates.liberty()[0]
        chartDataSet.axisDependency = .Left // Line will correlate with left axis values
        chartDataSet.setCircleColor(lineColor) // our circle will be dark red
        chartDataSet.circleRadius = 2.0 // the radius of the node circle
        chartDataSet.fillAlpha = 1
        chartDataSet.highlightColor = UIColor.yellowColor()
        chartDataSet.drawCircleHoleEnabled = true
        chartDataSet.drawCubicEnabled = false
        chartDataSet.cubicIntensity = 0.5;
        chartDataSet.setColor(lineColor)
        chartDataSet.drawValuesEnabled = false
        
        
        
        
        lineChartView!.leftAxis.drawGridLinesEnabled = true
        lineChartView!.leftAxis.drawAxisLineEnabled = false
        lineChartView!.leftAxis.axisLineColor = GlobalVariables.appThemeColorColor
        lineChartView!.leftAxis.gridColor = GlobalVariables.appThemeColorColor
        lineChartView!.leftAxis.gridLineWidth = 0.5


        lineChartView!.rightAxis.drawGridLinesEnabled = true
        lineChartView!.rightAxis.drawAxisLineEnabled = false
        lineChartView!.rightAxis.gridColor = UIColor.whiteColor()
        lineChartView!.rightAxis.gridLineWidth = 0

        lineChartView?.descriptionTextColor = UIColor.whiteColor()
        
        lineChartView!.xAxis.drawGridLinesEnabled = false
        lineChartView!.xAxis.drawAxisLineEnabled = false
        lineChartView?.getAxis(.Right).labelTextColor = UIColor.clearColor()
        lineChartView?.getAxis(.Left).labelTextColor = GlobalVariables.appThemeColorColor
        lineChartView?.getAxis(.Left).labelFont =   UIFont (name: "HelveticaNeue-Medium", size: 12)!

        //lineChartView!.xAxis.axisLineColor = UIColor.whiteColor()
        
        lineChartView?.drawBordersEnabled = false
        lineChartView?.descriptionText = ""
        lineChartView?.descriptionFont =  UIFont (name: "HelveticaNeue-Medium", size: 10)!
        
        let chartData = LineChartData(xVals: x, dataSet: chartDataSet)
        lineChartView!.data = chartData
    }
    
    //MARK: -chartView delegate
    

    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight)
    {
        print("\(entry.value) in \(entry.xIndex)")
        self.delegate?.didTapOnChartViewAtIndex(entry.xIndex)
    }
    
}



protocol ResultCellDelegate
{
    func didTapOnChartViewAtIndex(index:Int)
    func didTabOnAirportViewAtIndex(index:Int)
}


