{
  "Comment": "Example Retirement plus ServiceNow CMDB",
  "StartAt": "PreRetire",
  "States": {
    "PreRetire": {
      "Type": "Pass",
      "Next": "VmInfo",
        "Result": {
        "servicenow_instance_id": "dev252061",
        "servicenow_cmdb_table": "cmdb_ci_linux_server"
      }
    },
    "VmInfo": {
      "Type": "Task",
      "Resource": "manageiq://api",
      "Parameters": {
        "Url.$": "$$.Execution._object_details.href"
      },
      "Credentials": {
        "username.$": "$$.Credentials.manageiq_api_username",
        "password.$": "$$.Credentials.manageiq_api_password"
      },
      "ResultSelector": {
        "id.$": "$.Body.id",
        "name.$": "$.Body.name",
        "ems_ref.$": "$.Body.ems_ref"
      },
      "ResultPath": "$.vm",
      "Next": "QueryCmdbCi"
    },
    "QueryCmdbCi": {
      "Type": "Task",
      "Resource": "servicenow://cmdb/query_cis",
      "Parameters": {
        "instance_id.$": "$.servicenow_instance_id",
        "table.$": "$.servicenow_cmdb_table",
        "query.$": "States.Format('name={}', $.vm.name)"
      },
      "Credentials": {
        "username.$": "$$.Credentials.servicenow_username",
        "password.$": "$$.Credentials.servicenow_password"
      },
      "ResultSelector": {
        "sys_id.$": "$.result[0].sys_id"
      },
      "ResultPath": "$.cmdb_ci",
      "Next": "Retire"
    },
    "Retire": {
      "Type": "Task",
      "Resource": "manageiq://retire_execute",
      "Parameters": {
        "RemoveFromProvider": true,
        "RemoveFromProviderStorage": true,
        "RemoveFromInventory": true
      },
      "ResultPath": "$.retire_task",
      "Next": "DeleteCmdbCi"
    },
    "DeleteCmdbCi": {
      "Type": "Task",
      "Resource": "servicenow://cmdb/delete_ci",
      "Parameters": {
        "instance_id.$": "$.servicenow_instance_id",
        "table.$": "$.servicenow_cmdb_table",
        "sys_id.$": "$.cmdb_ci.sys_id"
      },
      "Credentials": {
        "username.$": "$$.Credentials.servicenow_username",
        "password.$": "$$.Credentials.servicenow_password"
      },
      "End": true
    }
  }
}
