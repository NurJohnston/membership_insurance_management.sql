-- exercise 12/04

CREATE TABLE Member (
    Member_ID INTEGER PRIMARY KEY,
    Member_Surname TEXT,
    Member_Cell_No TEXT,
    House_No INTEGER,
    Street_Name TEXT
    Member_DateOfBirth DATE
);

CREATE TABLE Beneficiary (
    Beneficiary_ID INTEGER PRIMARY KEY,
    Member_ID INTEGER,
    Beneficiary_Surname TEXT,
    Beneficiary_Cell_No TEXT,
    House_No INTEGER,
    Street_Name TEXT,
    Selected_Plan_ID INTEGER,
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID),
    FOREIGN KEY (Selected_Plan_ID) REFERENCES Selected_Plan(Selected_Plan_ID)
);

CREATE TABLE Account (
    Account_No INTEGER PRIMARY KEY,
    Account_Description TEXT,
    Date DATE
);

CREATE TABLE Selected_Plan (
    Selected_Plan_ID INTEGER PRIMARY KEY,
    Plan_ID INTEGER,
    Member_ID INTEGER,
    Account_No INTEGER,
    Date DATE,
    FOREIGN KEY (Plan_ID) REFERENCES Plan(Plan_ID),
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID),
    FOREIGN KEY (Account_No) REFERENCES Account(Account_No)
);

CREATE TABLE Plan (
    Plan_ID INTEGER PRIMARY KEY,
    Plan_Description TEXT,
    Price DECIMAL(10, 2)
);

CREATE TABLE Claim (
    Claim_ID INTEGER PRIMARY KEY,
    Claim_Description TEXT,
    Amount_Claimed DECIMAL(10, 2),
    Date DATE,
    Selected_Plan_ID INTEGER,
    FOREIGN KEY (Selected_Plan_ID) REFERENCES Selected_Plan(Selected_Plan_ID)
);

CREATE TABLE Payment (
    Payment_ID INTEGER PRIMARY KEY,
    Payment_Description TEXT,
    Amount_Paid DECIMAL(10, 2),
    Date DATE,
    Selected_Plan_ID INTEGER,
    FOREIGN KEY (Selected_Plan_ID) REFERENCES Selected_Plan(Selected_Plan_ID)
);

INSERT INTO Member (Member_ID, Member_Surname, Member_Cell_No, House_No, Street_Name)
VALUES
(1, 'Marlie', '123456789', 10, 'Lansdowne'),
(2, 'Johnston', '987654321', 20, 'Ottery'),
(3, 'Abrahams', '444444444', 30, 'Surrey');

INSERT INTO Beneficiary (Beneficiary_ID, Member_ID, Beneficiary_Surname, Beneficiary_Cell_No, House_No, Street_Name, Selected_Plan_ID)
VALUES
(1, 1, 'Marlie', '123456789', 10, 'Lansdowne', 1),
(2, 2, 'Johnston', '987654321', 20, 'Ottery', 2),
(3, 2, 'Abrahams', '444444444', 30, 'Surrey', 3);

INSERT INTO Account (Account_No, Account_Description, Date)
VALUES
(1, 'Savings', '2024-04-11'),
(2, 'Savings', '2024-04-11'),
(3, 'Investment', '2024-04-11');

INSERT INTO Selected_Plan (Selected_Plan_ID, Plan_ID, Member_ID, Account_No, Date)
VALUES
(1, 1, 1, 1, '2024-04-11'),
(2, 2, 2, 2, '2024-04-11'),
(3, 3, 3, 3, '2024-04-11');

INSERT INTO Plan (Plan_ID, Plan_Description, Price)
VALUES
(1, 'Basic', 50.00),
(2, 'Standard', 100.00),
(3, 'Premium', 150.00);

INSERT INTO Claim (Claim_ID, Claim_Description, Amount_Claimed, Date, Selected_Plan_ID)
VALUES
(1, 'Medical Expenses', 200.00, '2024-04-11', 1),
(2, 'Car Repair', 300.00, '2024-04-11', 2),
(3, 'Home Repair', 400.00, '2024-04-11', 3);

INSERT INTO Payment (Payment_ID, Payment_Description, Amount_Paid, Date, Selected_Plan_ID)
VALUES
(1, 'Medical Expenses Reimbursement', 200.00, '2024-04-11', 1),
(2, 'Car Repair Reimbursement', 300.00, '2024-04-11', 2),
(3, 'Home Repair Reimbursement', 400.00, '2024-04-11', 3);

UPDATE Member
SET Member_DateOfBirth = (
    CASE 
        WHEN Member_ID = 1 THEN '2002-05-25' -- Date of Birth for Marlie
        WHEN Member_ID = 2 THEN '2003-09-01' -- Date of Birth for Johnston
        WHEN Member_ID = 3 THEN '2003-06-06' -- Date of Birth for Abrahams
    END
);

-- exercise 20/04

-- q1
SELECT * FROM Member;

-- q2
SELECT Member_Surname, strftime('%Y', 'now') - strftime('%Y', Member_DateOfBirth) - (strftime('%m-%d', 'now') < strftime('%m-%d', Member_DateOfBirth)) AS Age
FROM Member;

-- q3
SELECT *
FROM Member
WHERE Member_ID IN (SELECT Member_ID FROM Beneficiary);

-- q4 
SELECT M.*
FROM Member M
JOIN Beneficiary B ON M.Member_ID = B.Member_ID
WHERE B.Selected_Plan_ID = 1;

-- q5
SELECT *
FROM Member
ORDER BY Member_Surname;

-- q6 
SELECT Member_Surname, strftime('%Y', 'now') - strftime('%Y', Member_DateOfBirth) - (strftime('%m-%d', 'now') < strftime('%m-%d', Member_DateOfBirth)) AS Age
FROM Member
ORDER BY Age DESC;

-- q7
SELECT M.*
FROM Member M
JOIN Selected_Plan SP ON M.Member_ID = SP.Member_ID
WHERE SP.Plan_ID = 1;

-- q8 
SELECT *
FROM Member
WHERE Member_ID NOT IN (SELECT DISTINCT Member_ID FROM Payment);

-- q9
SELECT M.Member_ID, M.Member_Surname, COUNT(B.Beneficiary_ID) AS Num_Beneficiaries
FROM Member M
LEFT JOIN Beneficiary B ON M.Member_ID = B.Member_ID
GROUP BY M.Member_ID;

-- q10
SELECT M.Member_ID, M.Member_Surname, COALESCE(SUM(P.Amount_Paid), 0) AS Total_Amount_Paid
FROM Member M
LEFT JOIN Selected_Plan SP ON M.Member_ID = SP.Member_ID
LEFT JOIN Payment P ON SP.Selected_Plan_ID = P.Selected_Plan_ID
GROUP BY M.Member_ID;

-- q11
SELECT 'Payment' AS Transaction_Type, Payment_ID AS Transaction_ID, Payment_Description AS Transaction_Description, Amount_Paid AS Amount, Date
FROM Payment
UNION ALL
SELECT 'Claim' AS Transaction_Type, Claim_ID AS Transaction_ID, Claim_Description AS Transaction_Description, Amount_Claimed AS Amount, Date
FROM Claim;

-- q12
SELECT A.*, SP.Plan_ID, SP.Member_ID, SP.Date
FROM Account A
JOIN Selected_Plan SP ON A.Account_No = SP.Account_No;


