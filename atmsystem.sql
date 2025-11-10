-- Drop child tables first
DROP TABLE TransferTransaction CASCADE CONSTRAINTS;
DROP TABLE WithdrawalTransaction CASCADE CONSTRAINTS;
DROP TABLE ATMTransaction CASCADE CONSTRAINTS;
DROP TABLE DebitCard CASCADE CONSTRAINTS;
DROP TABLE CheckingAccount CASCADE CONSTRAINTS;
DROP TABLE SavingsAccount CASCADE CONSTRAINTS;
DROP TABLE Account CASCADE CONSTRAINTS;
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE ATM CASCADE CONSTRAINTS;

-- Drop component tables (composition parts)
DROP TABLE Printer CASCADE CONSTRAINTS;
DROP TABLE Screen CASCADE CONSTRAINTS;
DROP TABLE Keypad CASCADE CONSTRAINTS;
DROP TABLE CashDispenser CASCADE CONSTRAINTS;
DROP TABLE CardReader CASCADE CONSTRAINTS;

-- Drop main parent table
DROP TABLE Bank CASCADE CONSTRAINTS;


CREATE OR REPLACE TYPE fullName AS OBJECT (
  firstName VARCHAR2(50),
  lastName  VARCHAR2(50)
);


CREATE OR REPLACE TYPE addressType AS OBJECT (
  street   VARCHAR2(100),
  city     VARCHAR2(50),
  zipCode  NUMBER,
  country  VARCHAR2(50)
);


CREATE TABLE Bank (
  bankId   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name     VARCHAR2(100) NOT NULL UNIQUE,
  address  addressType  -- optional address
);



CREATE TABLE ATM (
  atmId     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  bankId    NUMBER NOT NULL,
  location  VARCHAR2(100),  -- optional location
  FOREIGN KEY (bankId) REFERENCES Bank(bankId)
);




CREATE TABLE Customer (
  customerId  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  fullName    fullName NOT NULL,
  phone       VARCHAR2(15),  -- optional contact
  email       VARCHAR2(100),
  address     addressType,
  bankId      NUMBER NOT NULL,
  FOREIGN KEY (bankId) REFERENCES Bank(bankId)
);




CREATE TABLE Account (
  accountId     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customerId    NUMBER NOT NULL,
  balance       NUMBER(12,2) DEFAULT 0 NOT NULL,
  accountType   VARCHAR2(20) CHECK (accountType IN ('Savings', 'Checking')),
  UNIQUE(customerId, accountType),
  FOREIGN KEY (customerId) REFERENCES Customer(customerId)
);


--  SavingsAccount Table
CREATE TABLE SavingsAccount (
  savingsAccountId  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  accountId         NUMBER UNIQUE NOT NULL,
  interestRate      NUMBER(5, 2),
  FOREIGN KEY (accountId) REFERENCES Account(accountId)
);



--  CheckingAccount Table
CREATE TABLE CheckingAccount (
  checkingAccountId  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  accountId          NUMBER UNIQUE NOT NULL,
  overdraftLimit     NUMBER(12, 2) DEFAULT 0,
  FOREIGN KEY (accountId) REFERENCES Account(accountId)
);






CREATE TABLE DebitCard (
  cardId       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cardNumber   VARCHAR2(20) UNIQUE,
  expiryDate   DATE,
  pinHash      VARCHAR2(64),
  customerId   NUMBER NOT NULL,
  accountId    NUMBER NOT NULL UNIQUE,
  FOREIGN KEY (customerId) REFERENCES Customer(customerId),
  FOREIGN KEY (accountId) REFERENCES Account(accountId)
);



CREATE TABLE ATMTransaction (
  transactionId   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  transactionDate DATE DEFAULT SYSDATE,
  amount          NUMBER(12,2),
  status          VARCHAR2(20) CHECK (status IN ('Success', 'Failed', 'Pending')),
  accountId       NUMBER NOT NULL,
  atmId           NUMBER NOT NULL,
  FOREIGN KEY (accountId) REFERENCES Account(accountId),
  FOREIGN KEY (atmId) REFERENCES ATM(atmId)
);



-- ? WithdrawalTransaction Table
CREATE TABLE WithdrawalTransaction (
  withdrawalId     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  transactionId    NUMBER NOT NULL UNIQUE,
  withdrawalAmt    NUMBER(12, 2),
  FOREIGN KEY (transactionId) REFERENCES ATMTransaction(transactionId)
);










--  TransferTransaction Table
CREATE TABLE TransferTransaction (
  transferId        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  transactionId     NUMBER NOT NULL UNIQUE,
  transferAmt       NUMBER(12, 2),
  targetAccountId   NUMBER,
  FOREIGN KEY (transactionId) REFERENCES ATMTransaction(transactionId),
  FOREIGN KEY (targetAccountId) REFERENCES Account(accountId)
);







CREATE TABLE CardReader (
  readerId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  atmId    NUMBER,
  FOREIGN KEY (atmId) REFERENCES ATM(atmId)
);


CREATE TABLE CashDispenser (
  cashDispenserId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  atmId NUMBER NOT NULL,
  FOREIGN KEY (atmId) REFERENCES ATM(atmId)
);



CREATE TABLE Keypad (
    keypadId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    atmId NUMBER NOT NULL,
    FOREIGN KEY (atmId) REFERENCES ATM(atmId)
);


CREATE TABLE Screen (
    screenId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    atmId NUMBER NOT NULL,
    FOREIGN KEY (atmId) REFERENCES ATM(atmId)
);


CREATE TABLE Printer (
    printerId NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    atmId NUMBER NOT NULL,
    FOREIGN KEY (atmId) REFERENCES ATM(atmId)
);

INSERT INTO Bank (name, address)
VALUES (
  'Everest Bank',addressType('New Road, Bishal Bazar, Ward No. 11', 'Kathmandu', 44600, 'Nepal')
);
INSERT INTO Bank (name, address)
VALUES (
  'Lumbini Bank', addressType('Chipledhunga, Mahendrapool Chowk, Ward No. 9', 'Pokhara', 33700, 'Nepal')
);
INSERT INTO Bank (name, address)
VALUES (
  'Nepal SBI Bank',addressType('Gongabu, Samakhusi Marg, Ward No. 29', 'Kathmandu', 44600, 'Nepal')
);
INSERT INTO Bank (name, address)
VALUES (
  'Nabil Bank',addressType('Putalisadak, Kathmandu Metropolitan City, Ward No. 29', 'Kathmandu', 44600, 'Nepal')
);
INSERT INTO Bank (name, address)
VALUES (
  'NIC Asia',addressType('Birauta, Lakeside Road, Ward No. 6', 'Pokhara', 33700, 'Nepal')
);




INSERT INTO ATM (bankId, location) VALUES (1, 'Durbar Marg');
INSERT INTO ATM (bankId, location) VALUES (2, 'Lakeside');
INSERT INTO ATM (bankId, location) VALUES (3, 'Kalanki');
INSERT INTO ATM (bankId, location) VALUES (4, 'Chabahil');
INSERT INTO ATM (bankId, location) VALUES (5, 'Birauta Chowk');




INSERT INTO Customer (fullName, phone, email, address, bankId) VALUES (fullName('Rabin', 'Chhatuli'), '9864537328', 'rabin@gmail.com', addressType('Sundarbasti', 'Bharatpur', 44200, 'Nepal'), 1);

INSERT INTO Customer (fullName, phone, email, address, bankId) VALUES (fullName('Sita', 'Shrestha'), '9761342947', 'sita21@gmail.com', addressType('Baneshwor', 'Kathmandu', 44600, 'Nepal'), 2);

INSERT INTO Customer (fullName, phone, email, address, bankId) VALUES (fullName('Kiran', 'Basnet'), '9841122334', 'kiran@gmail.com', addressType('Hetauda Road', 'Hetauda', 44107, 'Nepal'), 3);

INSERT INTO Customer (fullName, phone, email, address, bankId) VALUES (fullName('Anita', 'Rai'), '9801010101', 'anita@gmail.com', addressType('Srijanachowk', 'Pokhara', 33700, 'Nepal'), 4);

INSERT INTO Customer (fullName, phone, email, address, bankId) VALUES (fullName('Manoj', 'Thapa'), '9811112222', 'manoj@gmail.com', addressType('Balaju', 'Kathmandu', 44600, 'Nepal'), 5);



INSERT INTO Account (customerId, balance, accountType) VALUES (1, 10000.00, 'Savings');
INSERT INTO Account (customerId, balance, accountType) VALUES (1, 3000.00, 'Checking');
INSERT INTO Account (customerId, balance, accountType) VALUES (2, 7000.00, 'Savings');
INSERT INTO Account (customerId, balance, accountType) VALUES (3, 9000.00, 'Checking');
INSERT INTO Account (customerId, balance, accountType) VALUES (4, 12000.00, 'Savings');



INSERT INTO SavingsAccount (accountId, interestRate) VALUES (1, 4.5);
INSERT INTO SavingsAccount (accountId, interestRate) VALUES (3, 4.0);
INSERT INTO SavingsAccount (accountId, interestRate) VALUES (5, 5.0);



INSERT INTO CheckingAccount (accountId, overdraftLimit) VALUES (2, 1000.00);
INSERT INTO CheckingAccount (accountId, overdraftLimit) VALUES (4, 1500.00);


INSERT INTO DebitCard (cardNumber, expiryDate, pinHash, customerId, accountId) VALUES 
('1234567890123456', TO_DATE('2026-12-31', 'YYYY-MM-DD'), 'a1b2c3d4e5', 1, 1);

INSERT INTO DebitCard (cardNumber, expiryDate, pinHash, customerId, accountId) VALUES 
('1111222233334444', TO_DATE('2027-06-30', 'YYYY-MM-DD'), 'f6g7h8i9j0', 1, 2);

INSERT INTO DebitCard (cardNumber, expiryDate, pinHash, customerId, accountId) VALUES 
('5555666677778888', TO_DATE('2025-09-15', 'YYYY-MM-DD'), 'k1l2m3n4o5', 2, 3);

INSERT INTO DebitCard (cardNumber, expiryDate, pinHash, customerId, accountId) VALUES 
('9999000011112222', TO_DATE('2026-01-01', 'YYYY-MM-DD'), 'p6q7r8s9t0', 3, 4);

INSERT INTO DebitCard (cardNumber, expiryDate, pinHash, customerId, accountId) VALUES 
('8888777766665555', TO_DATE('2028-08-31', 'YYYY-MM-DD'), 'u1v2w3x4y5', 4, 5);




INSERT INTO ATMTransaction (transactionDate, amount, status, accountId, atmId) VALUES (SYSDATE, 2000.00, 'Success', 1, 1);
INSERT INTO ATMTransaction (transactionDate, amount, status, accountId, atmId) VALUES (SYSDATE, 1500.00, 'Success', 3, 2);
INSERT INTO ATMTransaction (transactionDate, amount, status, accountId, atmId) VALUES (SYSDATE, 1000.00, 'Failed', 2, 3);
INSERT INTO ATMTransaction (transactionDate, amount, status, accountId, atmId) VALUES (SYSDATE, 2500.00, 'Success', 4, 4);
INSERT INTO ATMTransaction (transactionDate, amount, status, accountId, atmId) VALUES (SYSDATE, 3000.00, 'Pending', 5, 5);


INSERT INTO WithdrawalTransaction (transactionId, withdrawalAmt) VALUES (1, 2000.00);
INSERT INTO WithdrawalTransaction (transactionId, withdrawalAmt) VALUES (3, 1000.00);
INSERT INTO WithdrawalTransaction (transactionId, withdrawalAmt) VALUES (4, 2500.00);



INSERT INTO TransferTransaction (transactionId, transferAmt, targetAccountId) VALUES (2, 1500.00, 1);
INSERT INTO TransferTransaction (transactionId, transferAmt, targetAccountId) VALUES (5, 3000.00, 3);



INSERT INTO CardReader (atmId) VALUES (1);
INSERT INTO CardReader (atmId) VALUES (2);
INSERT INTO CardReader (atmId) VALUES (3);
INSERT INTO CardReader (atmId) VALUES (4);
INSERT INTO CardReader (atmId) VALUES (5);




INSERT INTO CashDispenser (atmId) VALUES (1);
INSERT INTO CashDispenser (atmId) VALUES (2);
INSERT INTO CashDispenser (atmId) VALUES (3);
INSERT INTO CashDispenser (atmId) VALUES (4);
INSERT INTO CashDispenser (atmId) VALUES (5);


INSERT INTO Keypad (atmId) VALUES (1);
INSERT INTO Keypad (atmId) VALUES (2);
INSERT INTO Keypad (atmId) VALUES (3);
INSERT INTO Keypad (atmId) VALUES (4);
INSERT INTO Keypad (atmId) VALUES (5);




INSERT INTO Screen (atmId) VALUES (1);
INSERT INTO Screen (atmId) VALUES (2);
INSERT INTO Screen (atmId) VALUES (3);
INSERT INTO Screen (atmId) VALUES (4);
INSERT INTO Screen (atmId) VALUES (5);


INSERT INTO Printer (atmId) VALUES (1);
INSERT INTO Printer (atmId) VALUES (2);
INSERT INTO Printer (atmId) VALUES (3);
INSERT INTO Printer (atmId) VALUES (4);
INSERT INTO Printer (atmId) VALUES (5);


select *from  Printer

commit;




DROP PROCEDURE perform_withdrawal_transaction;


CREATE OR REPLACE PROCEDURE perform_withdrawal_transaction (
  p_accountId   IN NUMBER,
  p_atmId       IN NUMBER,
  p_amount      IN NUMBER,
  p_status      OUT VARCHAR2
)
AS
  v_balance         NUMBER(12,2);
  v_overdraftLimit  NUMBER(12,2) := 0;
  v_accountType     VARCHAR2(20);
  v_transactionId   NUMBER;
  v_atmExists       NUMBER;
  v_accountExists   NUMBER;
BEGIN
  p_status := 'Failed: Unknown';

  IF p_amount IS NULL OR p_amount <= 0 THEN
    p_status := 'Failed: Invalid amount';
    RETURN;
  END IF;

  SELECT COUNT(*) INTO v_accountExists FROM Account WHERE accountId = p_accountId;
  IF v_accountExists = 0 THEN
    p_status := 'Failed: Account not found';
    RETURN;
  END IF;

  SELECT COUNT(*) INTO v_atmExists FROM ATM WHERE atmId = p_atmId;
  IF v_atmExists = 0 THEN
    p_status := 'Failed: ATM not found';
    RETURN;
  END IF;

  SELECT balance, accountType INTO v_balance, v_accountType FROM Account WHERE accountId = p_accountId;

  IF v_accountType = 'Checking' THEN
    BEGIN
      SELECT overdraftLimit INTO v_overdraftLimit FROM CheckingAccount WHERE accountId = p_accountId;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      v_overdraftLimit := 0;
    END;
  END IF;

  IF v_balance + v_overdraftLimit < p_amount THEN
    p_status := 'Failed: Insufficient funds';
    RETURN;
  END IF;

  SAVEPOINT sp_withdrawal;

  INSERT INTO ATMTransaction (
    accountId, atmId, amount, transactionDate, status
  ) VALUES (
    p_accountId, p_atmId, p_amount, SYSTIMESTAMP, 'Pending'
  ) RETURNING transactionId INTO v_transactionId;

  INSERT INTO WithdrawalTransaction (transactionId, withdrawalAmt)
  VALUES (v_transactionId, p_amount);

  UPDATE Account SET balance = balance - p_amount WHERE accountId = p_accountId;

  UPDATE ATMTransaction SET status = 'Success' WHERE transactionId = v_transactionId;

  COMMIT;
  p_status := 'Success';

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO sp_withdrawal;
    DELETE FROM WithdrawalTransaction WHERE transactionId = v_transactionId;
    DELETE FROM ATMTransaction WHERE transactionId = v_transactionId;
    p_status := 'Failed: ' || SQLERRM;
    ROLLBACK; -- ensures cleanup beyond the savepoint
END perform_withdrawal_transaction;
/

DECLARE
  v_status VARCHAR2(100);
BEGIN
  -- Test with sample input values
  perform_withdrawal_transaction(
    p_accountId => 1,    -- Existing Account ID
    p_atmId     => 101,  -- Existing ATM ID
    p_amount    => 1000, -- Amount to withdraw
    p_status    => v_status
  );

  DBMS_OUTPUT.PUT_LINE('Transaction Status: ' || v_status);
END;
/

SET SERVEROUTPUT ON;
DECLARE v_stat VARCHAR2(100);
BEGIN
  perform_withdrawal_transaction(2,1,500,v_stat);
  DBMS_OUTPUT.PUT_LINE('Status: ' || v_stat);
END;














SELECT 
    c.fullName.firstName || ' ' || c.fullName.lastName AS customer_name,
    a.accountType,
    t.amount,
    atm.location AS atm_location
FROM 
    Customer c
INNER JOIN 
    Account a ON c.customerId = a.customerId
LEFT OUTER JOIN 
    ATMTransaction t ON a.accountId = t.accountId
INNER JOIN 
    WithdrawalTransaction wt ON t.transactionId = wt.transactionId
INNER JOIN 
    ATM atm ON t.atmId = atm.atmId
WHERE 
    t.status = 'Success' AND t.amount > 2000;


SELECT 
    a.accountId,
    c.fullName.firstName || ' ' || c.fullName.lastName AS customer_name,
    'Savings' AS account_type
FROM 
    Account a
JOIN SavingsAccount s ON a.accountId = s.accountId
JOIN Customer c ON a.customerId = c.customerId
UNION
SELECT 
    a.accountId,
    c.fullName.firstName || ' ' || c.fullName.lastName AS customer_name,
    'Checking' AS account_type
FROM 
    Account a
JOIN CheckingAccount ch ON a.accountId = ch.accountId
JOIN Customer c ON a.customerId = c.customerId;




CREATE OR REPLACE FUNCTION format_customer_name(p_fullName fullName) 
RETURN VARCHAR2 IS
BEGIN
    RETURN p_fullName.firstName || ' ' || p_fullName.lastName;
END;
/


SELECT 
    format_customer_name(c.fullName) AS customer_name,
    c.address.city AS customer_city,
    b.name AS bank_name
FROM 
    Customer c
JOIN 
    Bank b ON c.bankId = b.bankId
WHERE 
    b.name = 'Nabil Bank';



SELECT 
    t.transactionId,
    t.transactionDate,
    SYSTIMESTAMP AS current_time,
    EXTRACT(DAY FROM (SYSTIMESTAMP - CAST(t.transactionDate AS TIMESTAMP))) AS days_elapsed,
    EXTRACT(HOUR FROM (SYSTIMESTAMP - CAST(t.transactionDate AS TIMESTAMP))) AS hours_elapsed
FROM 
    ATMTransaction t
WHERE 
    t.transactionDate >= SYSDATE - INTERVAL '60' DAY
ORDER BY 
    t.transactionDate DESC;







-- Create or replace the stored procedure
CREATE OR REPLACE PROCEDURE get_transaction_analytics(p_result OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN p_result FOR
    SELECT 
        b.name AS bank_name,
        t.status,
        SUM(t.amount) AS total_transaction_amount
    FROM 
        ATMTransaction t
    JOIN 
        Account a ON t.accountId = a.accountId
    JOIN 
        ATM atm ON t.atmId = atm.atmId
    JOIN 
        Bank b ON atm.bankId = b.bankId
    GROUP BY 
        CUBE (b.name, t.status)
    ORDER BY 
        b.name, t.status;
END;
/



-- Enable server output for displaying results
SET SERVEROUTPUT ON;

-- Test block for get_transaction_analytics procedure
DECLARE
    l_cursor SYS_REFCURSOR;
    l_bank_name VARCHAR2(100);
    l_status VARCHAR2(20);
    l_total_amount NUMBER;
    l_row_count NUMBER := 0;
BEGIN
    -- Begin exception handling block
    BEGIN
        -- Call the stored procedure
        get_transaction_analytics(l_cursor);
        
        -- Print header for output
        DBMS_OUTPUT.PUT_LINE(RPAD('Bank Name', 30) || RPAD('Status', 15) || 'Total Amount');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 30, '-') || RPAD('-', 15, '-') || RPAD('-', 12, '-'));

        -- Fetch and display results
        LOOP
            FETCH l_cursor INTO l_bank_name, l_status, l_total_amount;
            EXIT WHEN l_cursor%NOTFOUND;
            
            -- Increment row counter
            l_row_count := l_row_count + 1;
            
            -- Format and display each row
            DBMS_OUTPUT.PUT_LINE(
                RPAD(NVL(l_bank_name, 'All Banks'), 30) ||
                RPAD(NVL(l_status, 'All Statuses'), 15) ||
                TO_CHAR(NVL(l_total_amount, 0), '999,999,999.99')
            );
        END LOOP;

        -- Check if any rows were returned
        IF l_row_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No data returned from the procedure.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Total rows retrieved: ' || l_row_count);
        END IF;

        -- Close the cursor
        CLOSE l_cursor;

    EXCEPTION
        WHEN OTHERS THEN
            -- Handle any errors during execution
            DBMS_OUTPUT.PUT_LINE('Error executing procedure: ' || SQLERRM);
            IF l_cursor%ISOPEN THEN
                CLOSE l_cursor;
            END IF;
    END;
END;
/



commit;




-- triggers


create user atmsystem identified by atm123;

grant connect, resource to atmsystem;

alter user atmsystem default tablespace users quota unlimited on users;




-- === 1. DROP SECTION ===

BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER trg_audit_atm_transaction';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -4080 THEN NULL; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ATMTransaction_Audit CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE ATMTransaction CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE Account CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE Customer CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TYPE fullName';
  EXECUTE IMMEDIATE 'DROP TYPE addressType';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -4043 THEN NULL; END IF;
END;
/

-- === 2. CREATE USER-DEFINED OBJECT TYPES ===

CREATE OR REPLACE TYPE fullName AS OBJECT (
  firstName VARCHAR2(50),
  lastName  VARCHAR2(50)
);
/

CREATE OR REPLACE TYPE addressType AS OBJECT (
  street   VARCHAR2(100),
  city     VARCHAR2(50),
  zipCode  NUMBER,
  country  VARCHAR2(50)
);
/

-- === 3. MAIN TABLES ===

CREATE TABLE Customer (
  customerId  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  fullName    fullName NOT NULL,
  contact     VARCHAR2(20),
  address     addressType
);

CREATE TABLE Account (
  accountId   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customerId  NUMBER NOT NULL,
  balance     NUMBER(10,2) DEFAULT 0,
  FOREIGN KEY (customerId) REFERENCES Customer(customerId)
);

CREATE TABLE ATMTransaction (
  transactionId   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  transactionDate DATE DEFAULT SYSDATE,
  amount          NUMBER(10,2),
  status          VARCHAR2(20),
  accountId       NUMBER,
  FOREIGN KEY (accountId) REFERENCES Account(accountId)
);
-- . AUDIT TABLE 
CREATE TABLE ATMTransaction_Audit (
  auditId         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  transactionId   NUMBER,
  actionType      VARCHAR2(10),
  oldAmount       NUMBER(10,2),
  newAmount       NUMBER(10,2),
  status          VARCHAR2(20),
  accountId       NUMBER,
  changedBy       VARCHAR2(100),
  changedOn       TIMESTAMP DEFAULT SYSTIMESTAMP
);
-- . TRIGGER 
CREATE OR REPLACE TRIGGER trg_audit_atm_transaction
AFTER INSERT OR UPDATE OR DELETE ON ATMTransaction
FOR EACH ROW
DECLARE
  v_actionType  VARCHAR2(10);
  v_oldAmount   NUMBER(10,2);
  v_newAmount   NUMBER(10,2);
  v_status      VARCHAR2(20);
  v_accountId   NUMBER;
BEGIN
  IF INSERTING THEN
    v_actionType := 'INSERT';
    v_newAmount := :NEW.amount;
    v_status := :NEW.status;
    v_accountId := :NEW.accountId;
  ELSIF UPDATING THEN
    v_actionType := 'UPDATE';
    v_oldAmount := :OLD.amount;
    v_newAmount := :NEW.amount;
    v_status := :NEW.status;
    v_accountId := :NEW.accountId;
  ELSIF DELETING THEN
    v_actionType := 'DELETE';
    v_oldAmount := :OLD.amount;
    v_status := :OLD.status;
    v_accountId := :OLD.accountId;
  END IF;

  INSERT INTO ATMTransaction_Audit (
    transactionId, actionType, oldAmount, newAmount,
    status, accountId, changedBy
  )
  VALUES (
    NVL(:NEW.transactionId, :OLD.transactionId),
    v_actionType,
    v_oldAmount,
    v_newAmount,
    v_status,
    v_accountId,
    SYS_CONTEXT('USERENV', 'SESSION_USER')
  );
END;
/



-- Insert more customers
INSERT INTO Customer (fullName, contact, address)
VALUES (fullName('Sita', 'Shrestha'), '9801112233', addressType('New Baneshwor', 'Kathmandu', 44600, 'Nepal'));

INSERT INTO Customer (fullName, contact, address)
VALUES (fullName('Kiran', 'Rai'), '9845123487', addressType('Mahendrapool', 'Pokhara', 33700, 'Nepal'));

-- Insert more accounts
INSERT INTO Account (customerId, balance) VALUES (2, 8000);  -- Sita
INSERT INTO Account (customerId, balance) VALUES (3, 9500);  -- Kiran

-- Insert transactions
INSERT INTO ATMTransaction ( amount, status, accountId)
VALUES ( 1500, 'Success', 2);  -- Sita
-- CORRECT: No transactionId specified

INSERT INTO ATMTransaction ( amount, status, accountId)
VALUES ( 1200, 'Failed', 3);  -- Kiran

INSERT INTO ATMTransaction ( amount, status, accountId)
VALUES ( 3000, 'Pending', 1);  -- Rabin

select *from ATMTransaction
-- Update transactions
UPDATE ATMTransaction SET amount = 1800 WHERE transactionId = 2;
UPDATE ATMTransaction SET status = 'Success', amount = 1250 WHERE transactionId = 3;

-- Delete transactions
DELETE FROM ATMTransaction WHERE transactionId = 4;

-- Final: Check audit logs
SELECT * FROM ATMTransaction_Audit ORDER BY changedOn DESC;

commit;













commit;
















