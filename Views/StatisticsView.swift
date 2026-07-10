import SwiftUI
import Charts

struct StatisticsView: View {

    let group: Group

    var stats: [CategoryStat] {
        ExpenseStatistics.categoryTotals(for: group)
    }

    var body: some View {

        List {

            Section("Spending by Category") {

                Chart(stats) { stat in

                    BarMark(
                        x: .value("Amount", stat.total),
                        y: .value("Category", stat.category)
                    )

                }
                .frame(height: 300)

            }

            Section("Breakdown") {

                ForEach(stats) { stat in

                    HStack {

                        Image(systemName:
                                ExpenseCategory.icon(for: stat.category)
                        )

                        Text(stat.category)

                        Spacer()

                        Text(
                            stat.total,
                            format: .currency(code: "USD")
                        )

                    }

                }

            }

        }
        .navigationTitle("Statistics")

    }

}
