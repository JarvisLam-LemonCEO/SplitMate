import Foundation
import SwiftData

struct Settlement: Identifiable {
    var id: String {
        "\(from.persistentModelID)-\(to.persistentModelID)-\(amount)"
    }

    let from: Member
    let to: Member
    let amount: Double
}

struct Balance {
    let member: Member
    var amount: Double
}

struct BalanceCalculator {

    static func balances(for group: Group) -> [Balance] {
        let activeMemberIDs = Set(group.members.map { $0.persistentModelID })

        var totals: [PersistentIdentifier: (member: Member, amount: Double)] = [:]

        for member in group.members {
            totals[member.persistentModelID] = (member, 0)
        }

        for expense in group.expenses {
            guard
                let payer = expense.paidBy,
                activeMemberIDs.contains(payer.persistentModelID)
            else { continue }

            let activeParticipants = expense.participants.filter {
                activeMemberIDs.contains($0.persistentModelID)
            }

            guard !activeParticipants.isEmpty else { continue }

            let share = expense.amount / Double(activeParticipants.count)

            totals[payer.persistentModelID, default: (payer, 0)].amount += expense.amount

            for participant in activeParticipants {
                totals[participant.persistentModelID, default: (participant, 0)].amount -= share
            }
        }
        
        
        // Process settled payments
        for payment in group.payments {
            guard
                let fromMember = group.members.first(where: { $0.name == payment.fromName }),
                let toMember = group.members.first(where: { $0.name == payment.toName })
            else { continue }

            totals[fromMember.persistentModelID, default: (fromMember, 0)].amount += payment.amount
            totals[toMember.persistentModelID, default: (toMember, 0)].amount -= payment.amount
        }

        return totals.values
            .map { Balance(member: $0.member, amount: rounded($0.amount)) }
            .filter { abs($0.amount) > 0.01 }
            .sorted { $0.amount > $1.amount }
    }

    static func settlements(for group: Group) -> [Settlement] {
        var creditors = balances(for: group)
            .filter { $0.amount > 0.01 }
            .sorted { $0.amount > $1.amount }

        var debtors = balances(for: group)
            .filter { $0.amount < -0.01 }
            .sorted { $0.amount < $1.amount }

        var results: [Settlement] = []

        while !creditors.isEmpty && !debtors.isEmpty {
            var creditor = creditors.removeFirst()
            var debtor = debtors.removeFirst()

            let payment = min(creditor.amount, -debtor.amount)

            if payment > 0.01 {
                results.append(
                    Settlement(
                        from: debtor.member,
                        to: creditor.member,
                        amount: rounded(payment)
                    )
                )
            }

            creditor.amount -= payment
            debtor.amount += payment

            if creditor.amount > 0.01 {
                creditors.append(creditor)
                creditors.sort { $0.amount > $1.amount }
            }

            if debtor.amount < -0.01 {
                debtors.append(debtor)
                debtors.sort { $0.amount < $1.amount }
            }
        }

        return results
    }

    private static func rounded(_ value: Double) -> Double {
        (value * 100).rounded() / 100
    }
}
