# SplitMate 💸

SplitMate is a modern iOS expense-splitting app built with **SwiftUI** and **SwiftData**. It helps groups of friends, roommates, classmates, or travelers track shared expenses and calculate who owes whom.

---

## 📱 Screenshots

| Home | Group | Add Expense | Settle Up |
|------|------|------|------|
| ![](Screenshots/Home.png) | ![](Screenshots/Group.png) | ![](Screenshots/AddExpense.png) | ![](Screenshots/SettleUp.png) |

---

## ✨ Features

### Groups
- Create and delete groups
- Choose a custom group icon
- Dashboard showing:
  - Total spent
  - Number of members
  - Number of expenses

### Members
- Add members
- Remove members with swipe-to-delete
- Automatically updates balances after member removal

### Expenses
- Add expenses
- Edit expenses
- Delete expenses
- Select who paid
- Choose participants
- Expense categories:
  - 🍕 Food
  - 🚗 Transport
  - 🏨 Hotel
  - 🛍 Shopping
  - 🎉 Entertainment
  - 📦 Other

### Balance Calculation
- Automatically calculates balances
- Generates simplified **"Who Owes Whom"** settlements
- Ignores deleted members safely

### Settings
- User profile
- Currency selection
- Light Mode
- Dark Mode
- System Appearance

---

## 🛠 Built With

- Swift 6
- SwiftUI
- SwiftData
- Xcode 16
- iOS 18+

---

## 📂 Project Structure

```
SplitMate
│
├── App
│   └── SplitMateApp.swift
│
├── Models
│   ├── Group.swift
│   ├── Member.swift
│   ├── Expense.swift
│   └── AppSettings.swift
│
├── Views
│   ├── ContentView.swift
│   ├── GroupDetailView.swift
│   ├── AddGroupView.swift
│   ├── AddMemberView.swift
│   ├── AddExpenseView.swift
│   ├── EditExpenseView.swift
│   ├── BalanceView.swift
│   └── SettingsView.swift
│
├── Components
│   ├── DashboardCardView.swift
│   ├── ExpenseRowView.swift
│   └── GroupRowView.swift
│
├── Services
│   ├── BalanceCalculator.swift
│   └── ExpenseCategory.swift
│
└── Assets
```

---

## 🧠 How It Works

Each expense stores:

- Title
- Amount
- Category
- Payer
- Participants

SplitMate then:

1. Calculates each participant's share.
2. Computes every member's net balance.
3. Simplifies payments into the minimum number of settlements.

### Example

Expense:

```
Pizza
$90

Paid by:
Alice

Participants:
Alice
Bob
Charlie
```

Each person owes:

```
$30
```

Balances:

```
Alice +60
Bob   -30
Charlie -30
```

Settlement:

```
Bob → Alice      $30

Charlie → Alice  $30
```

---

## 🎯 Future Features

- CloudKit Sync
- Sign in with Apple
- Invite Friends
- Receipt Scanner (Vision OCR)
- Swift Charts
- Widgets
- Live Activities
- Multiple Currencies
- Push Notifications
- Apple Watch App

---

## 🚀 Getting Started

### Requirements

- macOS Sequoia or later
- Xcode 16+
- iOS 18+

### Installation

```bash
git clone https://github.com/yourusername/SplitMate.git
```

Open:

```
SplitMate.xcodeproj
```

Run on an iPhone simulator or physical device.

---

## 📖 Learning Goals

This project demonstrates:

- SwiftUI Navigation
- SwiftData Relationships
- CRUD Operations
- MVVM-inspired Architecture
- Reusable Components
- Custom Business Logic
- State Management
- Modern iOS Design


## 📄 License

This project is licensed under the MIT License.
