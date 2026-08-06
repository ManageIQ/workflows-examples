{
  "Comment": "List CMDB Tables with Transformed Output",
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
        "fields": "name,label"
      },
      "ResultPath": "$.values",
      "Next": "TransformResults"
    },
    "TransformResults": {
      "Type": "Map",
      "ItemsPath": "$.values.result",
      "ItemProcessor": {
        "ProcessorConfig": {
          "Mode": "INLINE"
        },
        "StartAt": "TransformItem",
        "States": {
          "TransformItem": {
            "Type": "Pass",
            "Parameters": {
              "transformed.$": "States.Array($.name, $.label)"
            },
            "OutputPath": "$.transformed",
            "End": true
          }
        }
      },
      "ResultPath": "$.values",
      "End": true
    }
  }
}
