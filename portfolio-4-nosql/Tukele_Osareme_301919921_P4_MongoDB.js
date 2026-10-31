// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("transfer_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("transfer_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "transfer_initiated",
                    "transfer_settled"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "transfer"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "transfer_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("transfer_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer_initiated",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "transfer_id": 5
            },
            "snapshot": {
                "transfer_id": 5,
                "from_account_id": 3,
                "to_account_id": 4,
                "amount": 25.5,
                "status": "settled",
                "created_at": "2026-01-14T10:00:00Z",
                "idempotency_key": "idem-1001"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "account_id": 3
                    },
                    "via": [
                        "transfer.from_account_id → account"
                    ]
                },
                {
                    "key": {
                        "account_id": 4
                    },
                    "via": [
                        "transfer.to_account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer_settled",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "transfer_id": 5
            },
            "snapshot": {
                "transfer_id": 5,
                "from_account_id": 3,
                "to_account_id": 4,
                "amount": 25.5,
                "status": "settled",
                "created_at": "2026-01-14T10:00:00Z",
                "idempotency_key": "idem-1001"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "account_id": 3
                    },
                    "via": [
                        "transfer.from_account_id → account"
                    ]
                },
                {
                    "key": {
                        "account_id": 4
                    },
                    "via": [
                        "transfer.to_account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "provider_reference": "illustrative provider_reference",
                "failure_code": "illustrative failure_code",
                "risk_score": "illustrative risk_score"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer_initiated",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "transfer_id": 6
            },
            "snapshot": {
                "transfer_id": 6,
                "from_account_id": 4,
                "to_account_id": 3,
                "amount": 10,
                "status": "pending",
                "created_at": "2026-01-15T10:00:00Z",
                "idempotency_key": "idem-1002"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "account_id": 4
                    },
                    "via": [
                        "transfer.from_account_id → account"
                    ]
                },
                {
                    "key": {
                        "account_id": 3
                    },
                    "via": [
                        "transfer.to_account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer_settled",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "transfer_id": 6
            },
            "snapshot": {
                "transfer_id": 6,
                "from_account_id": 4,
                "to_account_id": 3,
                "amount": 10,
                "status": "pending",
                "created_at": "2026-01-15T10:00:00Z",
                "idempotency_key": "idem-1002"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "account_id": 4
                    },
                    "via": [
                        "transfer.from_account_id → account"
                    ]
                },
                {
                    "key": {
                        "account_id": 3
                    },
                    "via": [
                        "transfer.to_account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "provider_reference": "illustrative provider_reference",
                "failure_code": "illustrative failure_code",
                "risk_score": "illustrative risk_score"
            }
        }
    }
]));
  await db.getCollection("transfer_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("transfer_events").find({"eventType":"transfer_initiated"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("transfer_events").find({"source.key.transfer_id":5}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("transfer_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("transfer_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("transfer_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "transfer_initiated",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "transfer",
        "key": {
            "transfer_id": 5
        },
        "snapshot": {
            "transfer_id": 5,
            "from_account_id": 3,
            "to_account_id": 4,
            "amount": 25.5,
            "status": "settled",
            "created_at": "2026-01-14T10:00:00Z",
            "idempotency_key": "idem-1001"
        }
    },
    "embedded": {},
    "references": {
        "account": [
            {
                "key": {
                    "account_id": 3
                },
                "via": [
                    "transfer.from_account_id → account"
                ]
            },
            {
                "key": {
                    "account_id": 4
                },
                "via": [
                    "transfer.to_account_id → account"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("transfer_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "transfer_initiated",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "transfer",
        "key": {
            "transfer_id": 5
        },
        "snapshot": {
            "transfer_id": 5,
            "from_account_id": 3,
            "to_account_id": 4,
            "amount": 25.5,
            "status": "settled",
            "created_at": "2026-01-14T10:00:00Z",
            "idempotency_key": "idem-1001"
        }
    },
    "embedded": {},
    "references": {
        "account": [
            {
                "key": {
                    "account_id": 3
                },
                "via": [
                    "transfer.from_account_id → account"
                ]
            },
            {
                "key": {
                    "account_id": 4
                },
                "via": [
                    "transfer.to_account_id → account"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("transfer_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
