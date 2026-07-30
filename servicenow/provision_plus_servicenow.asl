{
  "Comment": "Example Provisioning with ServiceNow CMDB",
  "StartAt": "PreProvision",
  "States": {
    "PreProvision": {
      "Type": "Pass",
      "Next": "Provision"
    },
    "Provision": {
      "Type": "Task",
      "Resource": "manageiq://provision_execute",
      "ResultPath": "$.provision_task",
      "Next": "VmInfo"
    },
    "VmInfo": {
      "Type": "Task",
      "Resource": "manageiq://api",
      "Parameters": {
        "Url.$": "$.provision_task.destination.href"
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
      "Next": "CreateCmdbCi"
    },
    "CreateCmdbCi": {
      "Type": "Task",
      "Resource": "servicenow://cmdb/create_ci",
      "Parameters": {
        "instance_id.$": "$.servicenow_instance_id",
        "table.$": "$.servicenow_cmdb_table",
        "name.$": "$.vm.name",
        "sys_class_name.$": "$.servicenow_cmdb_table",
        "owned_by": "System Administrator",
        "discovery_source": "Manual via IRE"
      },
      "Credentials": {
        "username.$": "$$.Credentials.servicenow_username",
        "password.$": "$$.Credentials.servicenow_password"
      },
      "End": true
    }
  }
}
