import Foundation

struct RestaurantSplitCalculator {
    static func tipAmount(subtotal: Double, tipPercentage: Double) -> Double {
        subtotal * tipPercentage / 100
    }

    static func total(subtotal: Double, tax: Double, tipPercentage: Double) -> Double {
        subtotal + tax + tipAmount(subtotal: subtotal, tipPercentage: tipPercentage)
    }

    static func perPerson(total: Double, peopleCount: Int) -> Double {
        guard peopleCount > 0 else { return 0 }
        return total / Double(peopleCount)
    }
}
