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

}

class ChartCellSpeedCell: UICollectionViewCell {
    @IBOutlet var lineChartView:LineChartView?
    
    // DB store
    var traceEvent:TraceEvent?
    var dataEntries: [BarChartDataEntry] = []
    var x:[Int] = []
    
    func loadCell()
    {
        dataEntries.removeAll()
        x.removeAll()
        if let traceEvent = self.traceEvent
        {
            var index = 0
            for location in traceEvent.traceLocations
            {
                let dataEntry = BarChartDataEntry(value: location.locationSpeed, xIndex: index)
                dataEntries.append(dataEntry)
                x.append(index)
                index++
            }
        }

        //lineChartView?.data?.setValueTextColor(UIColor.clearColor())
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "kts")
        chartDataSet.lineWidth = 2
        chartDataSet.fillColor = ChartColorTemplates.liberty()[0]
        chartDataSet.axisDependency = .Left // Line will correlate with left axis values
        //set1.setColor(UIColor.redColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        chartDataSet.setCircleColor(UIColor.redColor()) // our circle will be dark red
        chartDataSet.circleRadius = 1.0 // the radius of the node circle
        chartDataSet.fillAlpha = 1
        chartDataSet.highlightColor = UIColor.whiteColor()
        chartDataSet.drawCircleHoleEnabled = true
        chartDataSet.valueTextColor = UIColor.clearColor()
        chartDataSet.drawCubicEnabled = true
        chartDataSet.cubicIntensity = 0.5;
        
        lineChartView!.leftAxis.drawGridLinesEnabled = true
        lineChartView!.leftAxis.drawAxisLineEnabled = false
        lineChartView!.rightAxis.drawGridLinesEnabled = true
        lineChartView!.rightAxis.drawAxisLineEnabled = false
        
        lineChartView!.xAxis.drawGridLinesEnabled = false
        lineChartView!.xAxis.drawAxisLineEnabled = false
        
        lineChartView?.drawBordersEnabled = false
        
        let chartData = LineChartData(xVals: x, dataSet: chartDataSet)
        lineChartView!.data = chartData
    }
    
}


