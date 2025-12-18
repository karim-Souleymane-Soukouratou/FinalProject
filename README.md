#  E-Bourse ANAB Niger 
## 1. Live Website Access
The system is fully deployed and ready for review at:  
 [http://169.239.251.102:341/~soukouratou.souleymane/FinalProject/](http://169.239.251.102:341/~soukouratou.souleymane/FinalProject/)

---

## 2. Testing Credentials

### Administrator Access (Full Control)
- **Username:** `karim`  
- **Password:** `@karim12345`  
*Features: Financial Dashboard, Add Student/Admin, Bank Verification, Payment File Generation.*

### 🎓 Student Account Activation (User Flow)
To test the student registration and activation flow:
- **Scholar ID:** `STU009`
- **Instructions:** Navigate to the **"Activate Account"** page. Enter the Scholar ID above, then set your own email, password, and phone number (Format: +227 followed by 8 digits, e.g., `+22790000009`).

---

## 3. Key Features to Test
### For Administrators:
* **Dynamic Dashboard:** Real-time updates of Paid vs. Pending scholarship funds.
* **Payment Run:** Generate the official bank CSV file and schedule disbursements.
* **User Management:** Add new students or administrative staff directly from the UI.
* **Bank Verification:** Approve or reject student-submitted bank details.

### For Students:
* **Profile Management:** Update bank information (Bank Name, Account Number, IBAN).
* **Payment History:** View personal disbursement status and history.

---
## 4. Technical Notes
* **No Installation Required:** The project is hosted on a remote server.
* **Security:** Password hashing (BCRYPT) and role-based access control (RBAC) are implemented to protect financial data.
