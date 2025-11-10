

// Step 1: Select the Database

use atmsystemDB;








//  Step 2: Drop Existing Collections

db.banks.drop();
db.atms.drop();
db.customers.drop();
db.atmTransactions.drop();





//  Step 3: Create `banks` Collection

db.createCollection("banks", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["_id", "name"],
            properties: {
                _id: { bsonType: "string" },
                name: { bsonType: "string" },
                address: {
                    bsonType: "object",
                    properties: {
                        street: { bsonType: "string" },
                        city: { bsonType: "string" },
                        zipCode: { bsonType: "int" },
                        country: { bsonType: "string" }
                    }
                }
            }
        }
    }
});

// Step 4: Insert Bank Data

db.banks.insertMany([
    {
        _id: "001",
        name: "Everest Bank",
        address: {
            street: "New Road, Bishal Bazar, Ward No. 11",
            city: "Kathmandu",
            zipCode: 44600,
            country: "Nepal"
        }
    },
    {
        _id: "002",
        name: "Lumbini Bank",
        address: {
            street: "Chipledhunga, Mahendrapool Chowk, Ward No. 9",
            city: "Pokhara",
            zipCode: 33700,
            country: "Nepal"
        }
    },
    {
        _id: "003",
        name: "Nepal SBI Bank",
        address: {
            street: "Gongabu, Samakhusi Marg, Ward No. 29",
            city: "Kathmandu",
            zipCode: 44600,
            country: "Nepal"
        }
    },
    {
        _id: "004",
        name: "Nabil Bank",
        address: {
            street: "Putalisadak, Kathmandu Metropolitan City, Ward No. 29",
            city: "Kathmandu",
            zipCode: 44600,
            country: "Nepal"
        }
    },
    {
        _id: "005",
        name: "NIC Asia",
        address: {
            street: "Birauta, Lakeside Road, Ward No. 6",
            city: "Pokhara",
            zipCode: 33700,
            country: "Nepal"
        }
    }
]);






db.createCollection("atms", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["_id", "bankId", "location"],
            properties: {
                _id: { bsonType: "string" },
                bankId: { bsonType: "string" },
                location: { bsonType: "string" },
                cardReaders: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["readerId"],
                        properties: { readerId: { bsonType: "string" } }
                    }
                },
                cashDispensers: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["dispenserId"],
                        properties: { dispenserId: { bsonType: "string" } }
                    }
                },
                keypads: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["keypadId"],
                        properties: { keypadId: { bsonType: "string" } }
                    }
                },
                screens: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["screenId"],
                        properties: { screenId: { bsonType: "string" } }
                    }
                },
                printers: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["printerId"],
                        properties: { printerId: { bsonType: "string" } }
                    }
                }
            }
        }
    }
});



db.atms.insertMany([
    {
        _id: "101",
        bankId: "001",
        location: "Durbar Marg",
        cardReaders: [{ readerId: "201" }, { readerId: "202" }],
        cashDispensers: [{ dispenserId: "301" }],
        keypads: [{ keypadId: "401" }],
        screens: [{ screenId: "501" }],
        printers: [{ printerId: "601" }]
    },
    {
        _id: "102",
        bankId: "002",
        location: "Lakeside",
        cardReaders: [{ readerId: "203" }, { readerId: "204" }],
        cashDispensers: [{ dispenserId: "302" }],
        keypads: [{ keypadId: "402" }],
        screens: [{ screenId: "502" }],
        printers: [{ printerId: "602" }]
    },
    {
        _id: "103",
        bankId: "003",
        location: "Kalanki",
        cardReaders: [{ readerId: "205" }, { readerId: "206" }],
        cashDispensers: [{ dispenserId: "303" }],
        keypads: [{ keypadId: "403" }],
        screens: [{ screenId: "503" }],
        printers: [{ printerId: "603" }]
    },
    {
        _id: "104",
        bankId: "004",
        location: "Chabahil",
        cardReaders: [{ readerId: "207" }, { readerId: "208" }],
        cashDispensers: [{ dispenserId: "304" }],
        keypads: [{ keypadId: "404" }],
        screens: [{ screenId: "504" }],
        printers: [{ printerId: "604" }]
    },
    {
        _id: "105",
        bankId: "005",
        location: "Birauta Chowk",
        cardReaders: [{ readerId: "209" }, { readerId: "210" }],
        cashDispensers: [{ dispenserId: "305" }],
        keypads: [{ keypadId: "405" }],
        screens: [{ screenId: "505" }],
        printers: [{ printerId: "605" }]
    }
]);









db.createCollection("customers", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["_id", "fullName", "bankId"],
            properties: {
                _id: { bsonType: "string" },
                fullName: {
                    bsonType: "object",
                    required: ["firstName", "lastName"],
                    properties: {
                        firstName: { bsonType: "string" },
                        lastName: { bsonType: "string" }
                    }
                },
                phone: { bsonType: "string" },
                email: { bsonType: "string" },
                address: {
                    bsonType: "object",
                    properties: {
                        street: { bsonType: "string" },
                        city: { bsonType: "string" },
                        zipCode: { bsonType: "int" },
                        country: { bsonType: "string" }
                    }
                },
                bankId: { bsonType: "string" },
                accounts: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["accountId", "balance", "accountType"],
                        properties: {
                            accountId: { bsonType: "string" },
                            balance: { bsonType: ["double", "int"] },
                            accountType: { enum: ["Savings", "Checking"] },
                            interestRate: { bsonType: ["double", "int", "null"] },
                            overdraftLimit: { bsonType: ["double", "int", "null"] },
                            debitCards: {
                                bsonType: "array",
                                items: {
                                    bsonType: "object",
                                    required: ["cardId", "cardNumber", "expiryDate", "pinHash"],
                                    properties: {
                                        cardId: { bsonType: "string" },
                                        cardNumber: { bsonType: "string" },
                                        expiryDate: { bsonType: "date" },
                                        pinHash: { bsonType: "string" }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
});




db.customers.insertMany([
  {
    _id: "701",
    fullName: { firstName: "Rabin", lastName: "Chhatuli" },
    phone: "9864537328",
    email: "rabin@gmail.com",
    address: { street: "Sundarbasti", city: "Bharatpur", zipCode: 44200, country: "Nepal" },
    bankId: "001",
    accounts: [
      {
        accountId: "801",
        balance: 10000,
        accountType: "Savings",
        interestRate: 4.5,
        debitCards: [
          {
            cardId: "901",
            cardNumber: "1234567890123456",
            expiryDate: ISODate("2026-12-31"),
            pinHash: "a1b2c3d4e5"
          }
        ]
      },
      {
        accountId: "802",
        balance: 3000,
        accountType: "Checking",
        overdraftLimit: 1000.00,
        debitCards: [
          {
            cardId: "902",
            cardNumber: "1111222233334444",
            expiryDate: ISODate("2027-06-30"),
            pinHash: "f6g7h8i9j0"
          }
        ]
      }
    ]
  },
  {
    _id: "702",
    fullName: { firstName: "Sita", lastName: "Shrestha" },
    phone: "9761342947",
    email: "sita21@gmail.com",
    address: { street: "Baneshwor", city: "Kathmandu", zipCode: 44600, country: "Nepal" },
    bankId: "002",
    accounts: [
      {
        accountId: "803",
        balance: 7000,
        accountType: "Savings",
        interestRate: 4.0,
        debitCards: [
          {
            cardId: "903",
            cardNumber: "5555666677778888",
            expiryDate: ISODate("2025-09-15"),
            pinHash: "k1l2m3n4o5"
          }
        ]
      }
    ]
  },
  {
    _id: "703",
    fullName: { firstName: "Kiran", lastName: "Basnet" },
    phone: "9841122334",
    email: "kiran@gmail.com",
    address: { street: "Hetauda Road", city: "Hetauda", zipCode: 44107, country: "Nepal" },
    bankId: "003",
    accounts: [
      {
        accountId: "804",
        balance: 9000,
        accountType: "Checking",
        overdraftLimit: 1500.00,
        debitCards: [
          {
            cardId: "904",
            cardNumber: "9999000011112222",
            expiryDate: ISODate("2026-01-01"),
            pinHash: "p6q7r8s9t0"
          }
        ]
      }
    ]
  },
  {
    _id: "704",
    fullName: { firstName: "Anita", lastName: "Rai" },
    phone: "9801010101",
    email: "anita@gmail.com",
    address: { street: "Srijanachowk", city: "Pokhara", zipCode: 33700, country: "Nepal" },
    bankId: "004",
    accounts: [
      {
        accountId: "805",
        balance: 12000,
        accountType: "Savings",
        interestRate: 5.0,
        debitCards: [
          {
            cardId: "905",
            cardNumber: "8888777766665555",
            expiryDate: ISODate("2028-08-31"),
            pinHash: "u1v2w3x4y5"
          }
        ]
      }
    ]
  },
  {
    _id: "705",
    fullName: { firstName: "Manoj", lastName: "Thapa" },
    phone: "9811112222",
    email: "manoj@gmail.com",
    address: { street: "Balaju", city: "Kathmandu", zipCode: 44600, country: "Nepal" },
    bankId: "005",
    accounts: []
  },
  {
    _id: "706",
    fullName: { firstName: "Gita", lastName: "Poudel" },
    phone: "9801234567",
    email: "gita@gmail.com",
    address: { street: "Lazimpat", city: "Kathmandu", zipCode: 44600, country: "Nepal" },
    bankId: "001",
    accounts: [
      {
        accountId: "806",
        balance: 15000,
        accountType: "Savings",
        interestRate: 4.8,
        debitCards: [
          {
            cardId: "906",
            cardNumber: "7777888899990000",
            expiryDate: ISODate("2027-03-31"),
            pinHash: "z1y2x3w4v5"
          }
        ]
      }
    ]
  }
]);





db.createCollection("atmTransactions", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["_id", "transactionDate", "amount", "status", "accountId", "atmId", "transactionType"],
      properties: {
        _id: { bsonType: "string" },
        transactionDate: { bsonType: "date" },
        amount: { bsonType: "decimal" },
        status: { enum: ["Success", "Failed", "Pending"] },
        accountId: { bsonType: "string" },
        atmId: { bsonType: "string" },
        transactionType: { enum: ["Withdrawal", "Transfer"] },
        withdrawalAmt: { bsonType: ["decimal", "null"] },
        transferAmt: { bsonType: ["decimal", "null"] },
        targetAccountId: { bsonType: ["string", "null"] }
      }
    }
  }
});








db.atmTransactions.insertMany([
  {
    _id: "1001",
    transactionDate: ISODate("2025-06-25T10:11:00+05:45"),
    amount: NumberDecimal("2000.00"),
    status: "Success",
    accountId: "801",
    atmId: "101",
    transactionType: "Withdrawal",
    withdrawalAmt: NumberDecimal("2000.00")
  },
  {
    _id: "1002",
    transactionDate: ISODate("2025-06-25T10:11:00+05:45"),
    amount: NumberDecimal("1500.00"),
    status: "Success",
    accountId: "803",
    atmId: "102",
    transactionType: "Transfer",
    transferAmt: NumberDecimal("1500.00"),
    targetAccountId: "801"
  },
  {
    _id: "1003",
    transactionDate: ISODate("2025-06-25T10:11:00+05:45"),
    amount: NumberDecimal("1000.00"),
    status: "Failed",
    accountId: "802",
    atmId: "103",
    transactionType: "Withdrawal",
    withdrawalAmt: NumberDecimal("1000.00")
  },
  {
    _id: "1004",
    transactionDate: ISODate("2025-06-25T10:11:00+05:45"),
    amount: NumberDecimal("2500.00"),
    status: "Success",
    accountId: "804",
    atmId: "104",
    transactionType: "Withdrawal",
    withdrawalAmt: NumberDecimal("2500.00")
  },
  {
    _id: "1005",
    transactionDate: ISODate("2025-06-25T10:11:00+05:45"),
    amount: NumberDecimal("3000.00"),
    status: "Pending",
    accountId: "805",
    atmId: "105",
    transactionType: "Transfer",
    transferAmt: NumberDecimal("3000.00"),
    targetAccountId: "803"
  },
  {
    _id: "1006",
    transactionDate: ISODate("2025-06-25T10:11:00+05:45"),
    amount: NumberDecimal("500.00"),
    status: "Success",
    accountId: "806",
    atmId: "101",
    transactionType: "Withdrawal",
    withdrawalAmt: NumberDecimal("500.00")
  },
  {
    _id: "1007",
    transactionDate: ISODate("2025-06-25T10:11:00+05:45"),
    amount: NumberDecimal("2000.00"),
    status: "Success",
    accountId: "806",
    atmId: "101",
    transactionType: "Transfer",
    transferAmt: NumberDecimal("2000.00"),
    targetAccountId: "801"
  }
]);







// task6
//6.a
db.customers.aggregate([
  { $unwind: "$accounts" },
  {
    $lookup: {
      from: "atmTransactions",
      localField: "accounts.accountId",
      foreignField: "accountId",
      as: "transactions"
    }
  },
  { $unwind: "$transactions" },
  {
    $match: {
      "transactions.transactionType": "Withdrawal",
      "transactions.status": "Success",
      "transactions.amount": { $gt: 2000 }
    }
  },
  {
    $lookup: {
      from: "atms",
      localField: "transactions.atmId",
      foreignField: "_id",
      as: "atm"
    }
  },
  { $unwind: "$atm" },
  {
    $project: {
      _id: 0,
      customer_name: { $concat: ["$fullName.firstName", " ", "$fullName.lastName"] },
      accountType: "$accounts.accountType",
      amount: "$transactions.amount",
      atm_location: "$atm.location"
    }
  }
]).pretty();




//6.b
db.customers.aggregate([
  { $unwind: "$accounts" },
  {
    $project: {
      _id: 0,
      accountId: "$accounts.accountId",
      customer_name: { $concat: ["$fullName.firstName", " ", "$fullName.lastName"] },
      account_type: "$accounts.accountType"
    }
  }
]).pretty();




//6.c


db.system.js.save({
  _id: "format_customer_name",
  value: function(fullName) {
    return fullName.firstName + " " + fullName.lastName;
  }
});

db.customers.aggregate([
  {
    $lookup: {
      from: "banks",
      localField: "bankId",
      foreignField: "_id",
      as: "bank"
    }
  },
  { $unwind: "$bank" },
  { $match: { "bank.name": "Nabil Bank" } },
  {
    $project: {
      _id: 0,
      customer_name: { $function: { body: "function(fullName) { return fullName.firstName + ' ' + fullName.lastName; }", args: ["$fullName"], lang: "js" } },
      customer_city: "$address.city",
      bank_name: "$bank.name"
    }
  }
]).pretty();





//6.d


db.atmTransactions.aggregate([
  {
    $match: {
      transactionDate: { $gte: new Date(new Date().setDate(new Date().getDate() - 60)) }
    }
  },
  {
    $project: {
      _id: 0,
      transactionId: "$_id",
      transactionDate: "$transactionDate",
      current_time: new Date(),
      days_elapsed: {
        $floor: {
          $divide: [{ $subtract: [new Date(), "$transactionDate"] }, 1000 * 60 * 60 * 24]
        }
      },
      hours_elapsed: {
        $floor: {
          $divide: [{ $subtract: [new Date(), "$transactionDate"] }, 1000 * 60 * 60]
        }
      }
    }
  },
  { $sort: { transactionDate: -1 } }
]).pretty();







//6.e
db.atmTransactions.aggregate([
  {
    $lookup: {
      from: "atms",
      localField: "atmId",
      foreignField: "_id",
      as: "atm"
    }
  },
  { $unwind: "$atm" },
  {
    $lookup: {
      from: "banks",
      localField: "atm.bankId",
      foreignField: "_id",
      as: "bank"
    }
  },
  { $unwind: "$bank" },
  {
    $group: {
      _id: {
        bank_name: "$bank.name",
        status: "$status"
      },
      total_transaction_amount: { $sum: "$amount" }
    }
  },
  {
    $project: {
      _id: 0,
      bank_name: "$_id.bank_name",
      status: "$_id.status",
      total_transaction_amount: 1
    }
  },
  { $sort: { bank_name: 1, status: 1 } }
]).pretty();