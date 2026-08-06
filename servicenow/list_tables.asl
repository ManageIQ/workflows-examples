{
  "Comment": "List CMDB Tables",
  "StartAt": "ListTables",
  "States": {
    "ListTables": {
      "Type": "Task",
      "Resource": "servicenow://table/list_tables",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.dialog.dialog_instance_id",
        "query": "nameENDSWITHserver",
        "limit": 5,
        "fields": "name,label"
      },
      "ResultPath": "$.tables",
      "End": true
    }
  }
}
