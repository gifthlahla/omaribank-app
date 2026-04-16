# Omari Bank - Operations Summary

## 📋 All System Operations with Examples

### 🔐 Authentication (3 Operations)

| Operation | Input | Result | UI Screen |
|-----------|-------|--------|-----------|
| **Register** | email, password, name, phone | New account + wallet ($0.00) | `/register` |
| **Login** | email, password | Auth session + redirect to home | `/login` |
| **Logout** | Tap logout | Session cleared + redirect to login | `/profile` |

**Example:** Register new user
```json
{
  "email": "john@omaribank.com",
  "password": "JohnPass123!",
  "full_name": "John Doe",
  "phone": "+1555123456"
}
```
→ Account created, wallet initialized

---

### 💰 Wallet Operations (3 Operations)

| Operation | Input | Validation | Result | UI Screen |
|-----------|-------|------------|--------|-----------|
| **View Balance** | - | - | Real-time balance display | `/home` |
| **Deposit** | amount, description | $1-$10,000 | Balance +amount, new transaction | `/deposit` |
| **Withdraw** | amount, description | Sufficient funds, $1-$10,000 | Balance -amount, new transaction | `/withdraw` |

**Example:** Deposit $50.00
```json
Input: {"amount": 50.00, "description": "Paycheck deposit"}
Validation: Amount within limits ✓
Result: Balance $100 → $150, deposit transaction created
```

---

### 💸 Transaction Operations (3 Operations)

| Operation | Input | Validation | Result | UI Screen |
|-----------|-------|------------|--------|-----------|
| **Send Money** | recipient ID, amount, description | Valid recipient, sufficient funds | Sender -amount, receiver +amount | `/send` |
| **View History** | - | - | Real-time transaction list | `/transactions` |
| **View Details** | transaction ID | - | Full transaction info | `/transaction_detail` |

**Example:** Send $30.00 to friend
```json
Input: {
  "recipient_id": "user-2",
  "amount": 30.00,
  "description": "Movie tickets"
}
Validation: Sufficient balance ✓, recipient exists ✓
Result: Sender $100 → $70, Receiver $100 → $130
```

---

### 👤 Profile Operations (1 Operation)

| Operation | Input | Result | UI Screen |
|-----------|-------|--------|-----------|
| **View Profile** | - | User info + settings menu | `/profile` |

**Example:** View profile
```
Display:
👤 Gift Hlahla
📧 gifthlahla@omaribank.com
📱 +1234567890
[Settings options...]
[Logout button]
```

---

## 🔄 Real-Time Operations (2 Streams)

| Stream | Trigger | Update |
|--------|---------|--------|
| **Balance** | Deposits, withdrawals, transfers | Live balance display |
| **Transactions** | New transactions | Live history updates |

---

## ⚠️ Error Scenarios (4 Common Errors)

| Error | Cause | UI Message |
|-------|-------|------------|
| **Insufficient Funds** | Balance < amount | "You don't have enough balance" |
| **Invalid Recipient** | User doesn't exist | "Recipient account does not exist" |
| **Network Error** | No internet | "Check connection and try again" |
| **Invalid Amount** | < $1 or > $10,000 | "Amount must be between $1 and $10,000" |

---

## 💾 Database Tables (4 Tables)

| Table | Purpose | Key Fields |
|-------|---------|------------|
| **profiles** | User information | id, email, full_name, phone |
| **wallets** | Account balances | user_id, balance, currency |
| **transactions** | Money movements | sender_id, receiver_id, amount, type, description |
| **funding_requests** | Deposit/withdrawal audit | user_id, amount, type, status |

---

## 🔧 RPC Functions (3 Server-Side Operations)

| Function | Purpose | Security |
|----------|---------|----------|
| **transfer_money()** | P2P transfers | Server-side validation |
| **process_deposit()** | Add funds | Atomic transaction |
| **process_withdrawal()** | Remove funds | Balance check |

---

## 📱 UI Screens (8 Screens)

| Screen | Route | Purpose |
|--------|-------|---------|
| Login | `/login` | Email/password authentication |
| Register | `/register` | Create new account |
| Home | `/home` | Dashboard with balance & quick actions |
| Send Money | `/send` | P2P transfer form |
| Deposit | `/deposit` | Add funds form |
| Withdraw | `/withdraw` | Remove funds form |
| Transaction History | `/transactions` | Transaction list |
| Transaction Details | `/transaction_detail` | Single transaction info |
| Profile | `/profile` | User info & settings |

---

## 🧪 Test Data (2 Users)

| User | Email | Password | Balance | Transactions |
|------|-------|----------|---------|--------------|
| **Gift Hlahla** | gifthlahla@omaribank.com | gift1234 | $100.00 | Ready for testing |
| **Test User** | test2@omaribank.com | Test123! | $100.00 | Ready for testing |

---

## 🔄 Complete User Journey Example

1. **Register** → New account created
2. **Login** → Authenticated, redirected to home
3. **View Balance** → $0.00 displayed
4. **Deposit $200** → Balance becomes $200, deposit recorded
5. **Send $50 to friend** → Balance $150, friend gets $150, transfer recorded
6. **Check History** → Shows deposit (+$200) and transfer (-$50)
7. **View Transaction Details** → Full transfer information
8. **Withdraw $25** → Balance $125, withdrawal recorded
9. **View Profile** → Account information displayed
10. **Logout** → Session cleared, back to login

---

## 🔒 Security Features

- ✅ **Row-Level Security (RLS)** - Users see only their data
- ✅ **Server-Side Money Operations** - All transfers via RPC functions
- ✅ **Session Management** - Secure auth with Supabase
- ✅ **Input Validation** - Client and server-side validation
- ✅ **Atomic Transactions** - All-or-nothing money operations

---

## 📊 System Limits

| Limit | Value | Purpose |
|-------|-------|---------|
| **Min Transaction** | $1.00 | Prevent micro-transactions |
| **Max Transaction** | $10,000.00 | Risk management |
| **Password Length** | Min 6 chars | Security requirement |
| **Email Format** | RFC 5322 | Valid email addresses |
| **Phone Format** | International | Global compatibility |

---

## 🚀 Quick Test Commands

```bash
# Run the app
flutter run -d windows

# Test login with Gift
Email: gifthlahla@omaribank.com
Password: gift1234

# Test P2P transfer
Send $10.00 to test2@omaribank.com

# Check real-time updates
Watch balance change instantly
```

---

**Total Operations:** 10 core operations + 2 real-time streams  
**Test Users:** 2 fully configured accounts  
**Security:** Enterprise-grade with RLS and RPC functions  
**Real-Time:** Live balance and transaction updates  
**Status:** ✅ Production Ready
