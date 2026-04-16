# Omari Bank - System Operations Examples

**Date:** April 16, 2026  
**App Version:** 1.0.0  
**Backend:** Supabase PostgreSQL

---

## 📋 Test Users

| User ID | Email | Password | Full Name | Phone | Initial Balance |
|---------|-------|----------|-----------|-------|-----------------|
| `user-1` | gifthlahla@omaribank.com | gift1234 | Gift Hlahla | +1234567890 | $100.00 |
| `user-2` | test2@omaribank.com | Test123! | Test User | +0987654321 | $100.00 |

---

## 🔐 Authentication Operations

### 1. User Registration

**Operation:** Create new user account  
**Endpoint:** Supabase Auth API  
**Screen:** RegisterScreen (`/register`)

**Input Data:**
```json
{
  "email": "newuser@omaribank.com",
  "password": "SecurePass123!",
  "full_name": "John Doe",
  "phone": "+1555123456"
}
```

**Database Records Created:**
```sql
-- profiles table
INSERT INTO profiles (id, email, full_name, phone, created_at, updated_at)
VALUES ('new-user-id', 'newuser@omaribank.com', 'John Doe', '+1555123456', NOW(), NOW());

-- wallets table
INSERT INTO wallets (user_id, balance, currency, created_at, updated_at)
VALUES ('new-user-id', 0.00, 'USD', NOW(), NOW());
```

**UI Flow:**
1. User enters email, password, full name, phone
2. Form validation passes
3. Supabase creates auth user
4. Profile and wallet records created
5. Redirect to `/home`
6. Success message: "Account created successfully!"

### 2. User Login

**Operation:** Authenticate existing user  
**Endpoint:** Supabase Auth API  
**Screen:** LoginScreen (`/login`)

**Input Data:**
```json
{
  "email": "gifthlahla@omaribank.com",
  "password": "gift1234"
}
```

**Response:**
```json
{
  "user": {
    "id": "user-1",
    "email": "gifthlahla@omaribank.com",
    "user_metadata": {
      "full_name": "Gift Hlahla",
      "phone": "+1234567890"
    }
  },
  "session": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "refresh-token-here",
    "expires_at": 1640995200
  }
}
```

**UI Flow:**
1. User enters email and password
2. Form validation passes
3. Supabase authenticates user
4. Session created and stored
5. Redirect to `/home`
6. Real-time wallet balance loads

### 3. Logout

**Operation:** End user session  
**Endpoint:** Supabase Auth API  
**Screen:** ProfileScreen (`/profile`)

**Process:**
```dart
await Supabase.instance.client.auth.signOut();
```

**UI Flow:**
1. User taps "Logout" in profile screen
2. Confirmation dialog appears
3. User confirms logout
4. Supabase session cleared
5. Redirect to `/login`
6. Success message: "Logged out successfully"

---

## 💰 Wallet Operations

### 4. View Balance (Real-Time)

**Operation:** Display current wallet balance  
**Endpoint:** Supabase Real-time Stream  
**Screen:** HomeScreen (`/home`)

**Stream Query:**
```sql
SELECT * FROM wallets WHERE user_id = 'user-1';
```

**Sample Data:**
```json
{
  "user_id": "user-1",
  "balance": 100.00,
  "currency": "USD",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

**UI Display:**
```
Balance: $100.00
Currency: USD
Last Updated: Just now
```

### 5. Deposit Money

**Operation:** Add funds to wallet  
**Endpoint:** Supabase RPC `process_deposit()`  
**Screen:** DepositScreen (`/deposit`)

**Input Data:**
```json
{
  "user_id": "user-1",
  "amount": 50.00,
  "description": "Bank transfer deposit"
}
```

**RPC Function Call:**
```sql
SELECT process_deposit('user-1', 50.00, 'Bank transfer deposit');
```

**Database Changes:**
```sql
-- wallets table (balance updated)
UPDATE wallets SET balance = balance + 50.00, updated_at = NOW()
WHERE user_id = 'user-1';

-- transactions table (new record)
INSERT INTO transactions (id, sender_id, receiver_id, amount, type, description, status, created_at)
VALUES (gen_random_uuid(), NULL, 'user-1', 50.00, 'deposit', 'Bank transfer deposit', 'completed', NOW());

-- funding_requests table (audit trail)
INSERT INTO funding_requests (user_id, amount, type, status, created_at)
VALUES ('user-1', 50.00, 'deposit', 'completed', NOW());
```

**Result:**
- Wallet balance: $100.00 → $150.00
- New transaction record created
- Real-time balance update via stream

**UI Flow:**
1. User enters amount ($50.00)
2. Form validation passes
3. Confirmation dialog: "Deposit $50.00?"
4. RPC function called
5. Success message: "Deposit successful!"
6. Balance updates in real-time
7. Transaction appears in history

### 6. Withdraw Money

**Operation:** Remove funds from wallet  
**Endpoint:** Supabase RPC `process_withdrawal()`  
**Screen:** WithdrawScreen (`/withdraw`)

**Input Data:**
```json
{
  "user_id": "user-1",
  "amount": 25.00,
  "description": "ATM withdrawal"
}
```

**RPC Function Call:**
```sql
SELECT process_withdrawal('user-1', 25.00, 'ATM withdrawal');
```

**Database Changes:**
```sql
-- wallets table (balance updated)
UPDATE wallets SET balance = balance - 25.00, updated_at = NOW()
WHERE user_id = 'user-1';

-- transactions table (new record)
INSERT INTO transactions (id, sender_id, receiver_id, amount, type, description, status, created_at)
VALUES (gen_random_uuid(), 'user-1', NULL, 25.00, 'withdrawal', 'ATM withdrawal', 'completed', NOW());

-- funding_requests table (audit trail)
INSERT INTO funding_requests (user_id, amount, type, status, created_at)
VALUES ('user-1', 25.00, 'withdrawal', 'completed', NOW());
```

**Validation:**
- Balance check: Must have sufficient funds ($100.00 ≥ $25.00)
- Amount limits: $1.00 - $10,000.00 per transaction

**Result:**
- Wallet balance: $100.00 → $75.00
- New transaction record created

**UI Flow:**
1. User enters amount ($25.00)
2. Balance validation passes
3. Confirmation dialog: "Withdraw $25.00?"
4. RPC function called
5. Success message: "Withdrawal successful!"
6. Balance updates in real-time

---

## 💸 Transaction Operations

### 7. Send Money (P2P Transfer)

**Operation:** Transfer money between users  
**Endpoint:** Supabase RPC `transfer_money()`  
**Screen:** SendMoneyScreen (`/send`)

**Input Data:**
```json
{
  "sender_id": "user-1",
  "receiver_id": "user-2",
  "amount": 30.00,
  "description": "Dinner payment"
}
```

**RPC Function Call:**
```sql
SELECT transfer_money('user-1', 'user-2', 30.00, 'Dinner payment');
```

**Database Changes:**
```sql
-- Sender wallet (balance decreased)
UPDATE wallets SET balance = balance - 30.00, updated_at = NOW()
WHERE user_id = 'user-1';

-- Receiver wallet (balance increased)
UPDATE wallets SET balance = balance + 30.00, updated_at = NOW()
WHERE user_id = 'user-2';

-- transactions table (new record)
INSERT INTO transactions (id, sender_id, receiver_id, amount, type, description, status, created_at)
VALUES (gen_random_uuid(), 'user-1', 'user-2', 30.00, 'transfer', 'Dinner payment', 'completed', NOW());
```

**Validation:**
- Sender has sufficient balance ($100.00 ≥ $30.00)
- Receiver exists and has valid wallet
- Amount within limits ($1.00 - $10,000.00)

**Result:**
- Sender balance: $100.00 → $70.00
- Receiver balance: $100.00 → $130.00
- New transaction record created

**UI Flow:**
1. User enters recipient ID (user-2)
2. User enters amount ($30.00)
3. User enters description ("Dinner payment")
4. Form validation passes
5. Confirmation dialog: "Send $30.00 to user-2?"
6. RPC function called
7. Success message: "Money sent successfully!"
8. Both balances update in real-time
9. Transaction appears in both users' history

### 8. View Transaction History

**Operation:** Display user's transaction list  
**Endpoint:** Supabase Real-time Stream  
**Screen:** TransactionHistoryScreen (`/transactions`)

**Stream Query:**
```sql
SELECT * FROM transactions
WHERE sender_id = 'user-1' OR receiver_id = 'user-1'
ORDER BY created_at DESC;
```

**Sample Data (After Operations):**
```json
[
  {
    "id": "txn-001",
    "sender_id": "user-1",
    "receiver_id": "user-2",
    "amount": 30.00,
    "type": "transfer",
    "description": "Dinner payment",
    "status": "completed",
    "created_at": "2024-01-01T12:00:00Z"
  },
  {
    "id": "txn-002",
    "sender_id": null,
    "receiver_id": "user-1",
    "amount": 50.00,
    "type": "deposit",
    "description": "Bank transfer deposit",
    "status": "completed",
    "created_at": "2024-01-01T11:00:00Z"
  },
  {
    "id": "txn-003",
    "sender_id": "user-1",
    "receiver_id": null,
    "amount": 25.00,
    "type": "withdrawal",
    "description": "ATM withdrawal",
    "status": "completed",
    "created_at": "2024-01-01T10:00:00Z"
  }
]
```

**UI Display:**
```
Recent Transactions:
• Sent $30.00 to user-2 - "Dinner payment" - 2 hours ago
• Received $50.00 - "Bank transfer deposit" - 3 hours ago
• Withdrew $25.00 - "ATM withdrawal" - 4 hours ago
```

### 9. View Transaction Details

**Operation:** Display full transaction information  
**Endpoint:** Supabase Query  
**Screen:** TransactionDetailScreen (`/transaction_detail`)

**Query:**
```sql
SELECT * FROM transactions WHERE id = 'txn-001';
```

**Sample Data:**
```json
{
  "id": "txn-001",
  "sender_id": "user-1",
  "receiver_id": "user-2",
  "amount": 30.00,
  "type": "transfer",
  "description": "Dinner payment",
  "status": "completed",
  "created_at": "2024-01-01T12:00:00Z",
  "updated_at": "2024-01-01T12:00:00Z"
}
```

**UI Display:**
```
Transaction Details
Reference: txn-001
Type: Money Sent
Amount: $30.00
Recipient: user-2
Description: Dinner payment
Status: Completed
Date: January 1, 2024 at 12:00 PM

[Copy Reference] [Back to History]
```

---

## 👤 Profile Operations

### 10. View Profile

**Operation:** Display user profile information  
**Endpoint:** Supabase Query  
**Screen:** ProfileScreen (`/profile`)

**Query:**
```sql
SELECT * FROM profiles WHERE id = 'user-1';
```

**Sample Data:**
```json
{
  "id": "user-1",
  "email": "gifthlahla@omaribank.com",
  "full_name": "Gift Hlahla",
  "phone": "+1234567890",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

**UI Display:**
```
Profile
👤 Gift Hlahla
📧 gifthlahla@omaribank.com
📱 +1234567890

Settings
• Account Settings
• Security Settings
• Help & Support
• About

[Logout]
```

---

## 🔄 Real-Time Operations

### 11. Balance Updates

**Operation:** Live balance synchronization  
**Implementation:** Supabase Stream

**Stream Configuration:**
```dart
final stream = supabase
  .from('wallets')
  .stream(primaryKey: ['user_id'])
  .eq('user_id', userId)
  .listen((data) {
    // Update UI with new balance
    final wallet = WalletModel.fromJson(data.first);
    ref.read(walletProvider.notifier).updateBalance(wallet);
  });
```

**Trigger Events:**
- Deposit completion
- Withdrawal completion
- Money received from transfer
- Money sent in transfer

### 12. Transaction History Updates

**Operation:** Live transaction list synchronization  
**Implementation:** Supabase Stream

**Stream Configuration:**
```dart
final stream = supabase
  .from('transactions')
  .stream(primaryKey: ['id'])
  .or('sender_id.eq.${userId},receiver_id.eq.${userId}')
  .order('created_at', ascending: false)
  .listen((data) {
    // Update transaction list
    final transactions = data.map(TransactionModel.fromJson).toList();
    ref.read(transactionsProvider.notifier).updateTransactions(transactions);
  });
```

**Trigger Events:**
- New deposit
- New withdrawal
- New transfer (sent or received)

---

## ⚠️ Error Handling Examples

### 13. Insufficient Funds Error

**Operation:** Attempt withdrawal with insufficient balance  
**Input:** Amount $200.00, Balance $100.00

**Error Response:**
```json
{
  "error": "Insufficient funds",
  "message": "You don't have enough balance for this transaction",
  "code": "INSUFFICIENT_FUNDS"
}
```

**UI Display:**
```
❌ Error
You don't have enough balance for this transaction
```

### 14. Invalid Recipient Error

**Operation:** Send money to non-existent user  
**Input:** Recipient ID "invalid-user"

**Error Response:**
```json
{
  "error": "Recipient not found",
  "message": "The recipient account does not exist",
  "code": "RECIPIENT_NOT_FOUND"
}
```

**UI Display:**
```
❌ Error
The recipient account does not exist
```

### 15. Network Error

**Operation:** Any operation during network failure

**Error Response:**
```json
{
  "error": "Network error",
  "message": "Please check your internet connection and try again",
  "code": "NETWORK_ERROR"
}
```

**UI Display:**
```
❌ Error
Please check your internet connection and try again
[Retry]
```

---

## 📊 Complete User Flow Example

**Scenario:** New user registration → Login → Deposit → Send money → Check history → Logout

### Step 1: Registration
```json
POST /auth/signup
{
  "email": "alice@omaribank.com",
  "password": "AlicePass123!",
  "full_name": "Alice Johnson",
  "phone": "+1444555666"
}
```
**Result:** Account created, wallet initialized with $0.00

### Step 2: Login
```json
POST /auth/signin
{
  "email": "alice@omaribank.com",
  "password": "AlicePass123!"
}
```
**Result:** Authenticated, session created

### Step 3: Deposit $200.00
```sql
SELECT process_deposit('alice-user-id', 200.00, 'Initial deposit');
```
**Result:** Balance $0.00 → $200.00, deposit transaction created

### Step 4: Send $50.00 to Gift
```sql
SELECT transfer_money('alice-user-id', 'user-1', 50.00, 'Coffee money');
```
**Result:**
- Alice balance: $200.00 → $150.00
- Gift balance: $100.00 → $150.00
- Transfer transaction created

### Step 5: Check Transaction History
**Query:** All transactions for alice-user-id
**Result:**
- Deposit: +$200.00 "Initial deposit"
- Transfer: -$50.00 "Coffee money" to Gift

### Step 6: Logout
```json
POST /auth/signout
```
**Result:** Session cleared, redirected to login

---

## 🔒 Security Examples

### 16. Row-Level Security (RLS)

**Policy:** Users can only access their own data

```sql
-- Wallets table policy
CREATE POLICY "Users can view own wallet" ON wallets
FOR SELECT USING (auth.uid() = user_id);

-- Transactions table policy
CREATE POLICY "Users can view own transactions" ON transactions
FOR SELECT USING (auth.uid() = sender_id OR auth.uid() = receiver_id);
```

### 17. RPC Function Security

**Function:** transfer_money (server-side execution)

```sql
CREATE OR REPLACE FUNCTION transfer_money(
  sender_id UUID,
  receiver_id UUID,
  transfer_amount DECIMAL,
  transfer_description TEXT
)
RETURNS JSON AS $$
DECLARE
  sender_balance DECIMAL;
BEGIN
  -- Security: Check sender has sufficient funds
  SELECT balance INTO sender_balance FROM wallets WHERE user_id = sender_id;
  IF sender_balance < transfer_amount THEN
    RAISE EXCEPTION 'Insufficient funds';
  END IF;

  -- Security: Atomic transaction
  UPDATE wallets SET balance = balance - transfer_amount WHERE user_id = sender_id;
  UPDATE wallets SET balance = balance + transfer_amount WHERE user_id = receiver_id;

  -- Record transaction
  INSERT INTO transactions (sender_id, receiver_id, amount, type, description, status)
  VALUES (sender_id, receiver_id, transfer_amount, 'transfer', transfer_description, 'completed');

  RETURN json_build_object('status', 'success');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

## 📱 UI State Examples

### 18. Loading States

**Balance Loading:**
```dart
// Skeleton shimmer while loading
if (walletAsync.isLoading) {
  return SkeletonBalanceCard();
}

// Error state
if (walletAsync.hasError) {
  return ErrorWidget(error: walletAsync.error);
}

// Success state
return BalanceCard(balance: walletAsync.value!.balance);
```

### 19. Form Validation States

**Email Validation:**
```dart
final emailError = validateEmail(emailController.text);
// Display error if validation fails
if (emailError != null) {
  return Text(emailError, style: TextStyle(color: Colors.red));
}
```

### 20. Confirmation Dialogs

**Send Money Confirmation:**
```dart
showDialog(
  context: context,
  builder: (context) => ConfirmationDialog(
    title: 'Confirm Transfer',
    message: 'Send $30.00 to ${recipientName}?',
    onConfirm: () => performTransfer(),
  ),
);
```

---

## 🔄 Complete System State After All Operations

**Final Balances:**
- Gift Hlahla: $150.00 (initial $100 + $50 received - $30 sent + $50 deposit - $25 withdrawal = $145, wait let me recalculate)
Wait, let me fix the math:

Initial: $100
+ $50 deposit = $150
- $30 sent to user-2 = $120
- $25 withdrawal = $95

User-2: $100 (initial) + $30 received = $130

**Transaction History (Gift):**
1. Withdrawal: -$25.00 "ATM withdrawal"
2. Deposit: +$50.00 "Bank transfer deposit"
3. Transfer Sent: -$30.00 "Dinner payment" to user-2

**Transaction History (User-2):**
1. Transfer Received: +$30.00 "Dinner payment" from Gift

---

This comprehensive examples document covers all possible operations in the Omari Bank system with concrete data examples, database changes, UI flows, and error scenarios.
