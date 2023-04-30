//
//  BarbellView.swift
//  TrainingDay02
//
//  Created by William Hayden on 4/26/23.
//

import SwiftUI

struct BarbellView: View {
    var weight: Double
    var weightUnit: WeightUnit
    
    var body: some View {
            VStack {
                Spacer()
                ZStack(alignment: .center) {
                    HStack(alignment: .center, spacing: 0) {
                        Rectangle()
                            .frame(width: 20, height: 15)
                        Rectangle()
                            .padding(.trailing)
                            .frame(width: 250, height: 15)
                    }
                    HStack(alignment: .center) {
                        ForEach(getPlateWeights(for: weight, in: weightUnit), id: \.self) { plateWeight in
                            PlateView(weight: plateWeight, weightUnit: weightUnit, color: getPlateColor(for: plateWeight, in: weightUnit))
                        }
                    }
                }
                Spacer()
            }
        }
    func getPlateWeights(for weight: Double, in weightUnit: WeightUnit) -> [Double] {
        let increment = weightUnit == .pounds ? 5.0 : 2.5
        let roundedWeight = weightUnit == .pounds ? (weight / increment).rounded() * increment : (weight / increment).rounded(.toNearestOrEven) * increment
        let plateWeights: [Double]
        
        if weightUnit == .pounds {
            plateWeights = [45, 35, 25, 10, 5, 2.5]
        } else {
            plateWeights = [25, 20, 15, 10, 5, 2.5, 1.25]
        }
        
        var remainingWeight = (roundedWeight - (weightUnit == .pounds ? 45 : 20)) / 2
        var plateCount: [Double: Int] = [:]
        
        for plateWeight in plateWeights {
            let plateCountForWeight = Int(remainingWeight / plateWeight)
            remainingWeight -= Double(plateCountForWeight) * plateWeight
            plateCount[plateWeight] = plateCountForWeight
        }
        
        var plates: [Double] = []
        
        for (plateWeight, count) in plateCount {
            for _ in 0..<count {
                plates.append(plateWeight)
            }
        }
        
        return plates.sorted(by: >)
    }
    
    func getPlateColor(for weight: Double, in weightUnit: WeightUnit) -> Color {
        if weightUnit == .pounds {
            switch weight {
            case 45:
                return .blue
            case 35:
                return .yellow
            case 25:
                return .green
            case 10:
                return .black
            case 5:
                return .purple
            case 2.5:
                return .white
            default:
                return .clear
            }
        } else {
            switch weight {
            case 25:
                return .red
            case 20:
                return .blue
            case 15:
                return .yellow
            case 10:
                return .green
            case 5:
                return .black
            case 2.5:
                return .purple
            case 1.25:
                return .white
            default:
                return .clear
            }
        }
    }
}

struct PlateView: View {
    var weight: Double
    var weightUnit: WeightUnit
    var color: Color
    
    var body: some View {
        let plateSize = getSize(for: weight, in: weightUnit)
        Rectangle()
            .fill(color)
            .frame(width: plateSize.width, height: plateSize.height)
            .overlay(
                Text("\(Int(weight))")
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .font(.body)
                    .bold()
                    .foregroundColor(.white)
            )
    }
    
    func getSize(for weight: Double, in weightUnit: WeightUnit) -> CGSize {
        if weightUnit == .pounds {
            switch weight {
            case 45:
                return CGSize(width: 35, height: 150)
            case 35:
                return CGSize(width: 30, height: 130)
            case 25:
                return CGSize(width: 30, height: 110)
            case 10:
                return CGSize(width: 25, height: 90)
            case 5:
                return CGSize(width: 20, height: 70)
            case 2.5:
                return CGSize(width: 15, height: 50)
            default:
                return CGSize(width: 0, height: 0)
            }
        } else {
            switch weight {
            case 25:
                return CGSize(width: 40, height: 150)
            case 20:
                return CGSize(width: 35, height: 150)
            case 15:
                return CGSize(width: 30, height: 130)
            case 10:
                return CGSize(width: 30, height: 110)
            case 5:
                return CGSize(width: 25, height: 90)
            case 2.5:
                return CGSize(width: 20, height: 70)
            case 1.25:
                return CGSize(width: 15, height: 50)
            default:
                return CGSize(width: 0, height: 0)
            }
        }
    }
}


struct BarbellView_Previews: PreviewProvider {
    static var previews: some View {
        BarbellView(weight: 200, weightUnit: .kilograms)
    }
}
