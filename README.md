# gooddata-public-demos
Public Repository for GoodData Demos and Packages

# How to deploy sample data for a new demo workspace
This is an example of using gooddemo sample data

# Notice
If you are using GoodData.CN version 2.5.0 or older, use `ldm_v2.5.0.json`. For newer versions, use `ldm.json`.

## Before you start
1. There is an existing user in adminGroup
2. Prepare the data source for demo
   1. Connect to your snowflake data source, run the [snowflake.ddl](gooddemo/databases/ddl/snowflake.ddl) to create your demo data source
   2. Loading [sample data](gooddemo/databases/data) in .csv files into your snowflake data source if this is created in 2.1
* You can ignore this step if you just want to use the existing sample data source of gooddata (already defined in gooddemo sample data)
3. Setting the environment variables (replace the API_TOKEN and ENDPOINT value by yours) by command 
   1. You can generate API token according to the instructions in our documentation: [Use an API Token for Authentication](https://www.gooddata.com/developers/cloud-native/doc/hosted/manage-deployment/set-up-authentication/user-token/)
   2. For endpoint please use the full host name of your organization, e.g.: https://trial-demo-data.cloud.gooddata.com
```
API_TOKEN="<TOKEN>"
ENDPOINT="<endpoint url>"
```

## Step 1: Create data source
We will create a data source the same as [the existing GoodDemo data source](gooddemo/dataSource/dataSource.json)\
Using content body in this file, just replace the password value (, you can change the name and the id of your data source if required)\
You can also change the url, username and password if you have an existing one or you created it in Step 2 of ## Before you start\
For example:
```
curl --request POST \
  --header "Authorization: Bearer $API_TOKEN" \
  --header 'Content-Type: application/vnd.gooddata.api+json' \
  --data '{
      "data": {
        "attributes": {
          "name": "GDC Good Demo Data source",
          "url": "jdbc:snowflake://gooddata.snowflakecomputing.com?warehouse=GOODDATA_DEMO_WAREHOUSE&db=GOODDATA_DEMO_DATABASE",
          "schema": "GOODDATA_DEMO_SCHEMA",
          "type": "SNOWFLAKE",
          "username": "gooddata_demo",
          "password": "<your password>"
        },
        "id": "gdc_ds_gooddemo",
        "type": "dataSource"
      }
}' $ENDPOINT/api/v1/entities/dataSources
```

## Step 2: Create physical data model
We will create a data source the same as [the existing GoodDemo physical data model](gooddemo/dataSource/pdm.json)\
Using content body in this file, just replace the <dataSourceId> by id in Step 1, in this example, it is: gdc_ds_gooddemo\
For example:
```
curl --request PUT \
  --header "Authorization: Bearer $API_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '@./gooddemo/dataSource/pdm.json' $ENDPOINT/api/v1/layout/dataSources/<dataSourceId>/physicalModel
```

## Step 3: Create workspace
We will create a data source the same as [the existing GoodDemo / demo workspace](gooddemo/workspaces/demo/workspace.json)\
Using content body in this file, you can change the name and the id of your workspace if required\
For example:
```
curl --request POST \
  --header "Authorization: Bearer $API_TOKEN" \
  --header 'Content-Type: application/vnd.gooddata.api+json' \
  --data '{
  "data": {
    "attributes": {
      "name": "Demo analytics"
    },
    "id": "demo",
    "type": "workspace"
  }
}' $ENDPOINT/api/v1/entities/workspaces
```

## Step 4: Create analytics and logical data model for new workspace
Copy the content data of demo workspace [logical data model](gooddemo/workspaces/demo/ldm.json) and [analytics](gooddemo/workspaces/demo/workspaceAnalytics.json) into one model\
Replace the <workspaceId> by id in Step 3, in this example, it is: demo
And then perform the API call as below (replace model of ldm and analytics by the appropriate content from above files)
```
curl --request PUT \
  --header "Authorization: Bearer $API_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{
        "ldm": {...},
        "analytics": {...}
}' $ENDPOINT/api/v1/layout/workspaces/<workspaceId>
```

## Additional options
### Create logical data model only
We will create a workspace logical data model the same as [the existing demo workspace logical data model](gooddemo/workspaces/demo/ldm.json)\
Using content body in this file, just replace the <workspaceId> by id in Step 3, in this example, it is: demo\
For example:
```
curl --request PUT \
  --header "Authorization: Bearer $API_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '@./gooddemo/workspaces/demo/ldm.json' $ENDPOINT/api/v1/layout/workspaces/<workspaceId>
```
### Customize Theme for Organization and Workspace
To customize theme for organization or workspace we need create a theme object for organization 
##Step 1: Create a theme object
``` 
   curl --request POST \
  --header "Authorization: Bearer $API_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{
   "data": {
   "attributes": {
   "content": { 
      <content>
   },
   "name": "<some_name>"
   },
   "id": "<some_id>",
   "type": "theme"
   }
}' $ENDPOINT/api/v1/entities/themes
```
content can found in [theme.json](ecommerce-demo/organization/themes.json) in content of each object 
##Step 2: Create a theme object for organization or workspace
For Organization use
``` 
   curl --request POST \
  --header "Authorization: Bearer $API_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{
    "data": {
        "type": "organizationSetting",
        "id": "<setting_theme_id>",
        "attributes": {
            "content": {
                "id": "<themeId>",
                "type": "theme"
            },
            "type": "ACTIVE_THEME"
        }
    }
}' $ENDPOINT/api/v1/entities/organizationSettings/<setting_theme_id>
```
For Workspace use
``` 
   curl --request POST \
  --header "Authorization: Bearer $API_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{
    "data": {
        "type": "workspaceSetting",
        "id": "{settingsId}",
        "attributes": {
            "content": {
                "id": "{themeId}",
                "type": "theme"
            },
            "type": "ACTIVE_THEME"
        }
    }
}' $ENDPOINT/api/v1/entities/workspaces/{workspaceId}/workspaceSettings
```

### Customize ColorPalette for Organization and Workspace
To customize colorPalette for organization or workspace we need create a theme object for organization
##Step 1: Create a colorPalette object
``` 
   curl --request POST \
  --header "Authorization: Bearer $API_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{
   "data": {
   "attributes": {
   "content": { 
      <content>
   },
   "name": "<some_name>"
   },
   "id": "<some_id>",
   "type": "colorPalette"
   }
}' $ENDPOINT/api/v1/entities/colorPalette
```
content can found in [colorPalettes.json](ecommerce-demo/organization/colorPalettes.json) in attributes of each object
##Step 2: Create a colorPalette for organization or workspace
For Organization use
``` 
   curl --request POST \
  --header "Authorization: Bearer $API_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{
    "data": {
        "type": "organizationSetting",
        "id": "<setting_color_palette_id>",
        "attributes": {
            "content": {
                "id": "<colorPaletteId>",
                "type": "colorPalette"
            },
            "type": "ACTIVE_COLOR_PALETTE"
        }
    }
}' $ENDPOINT/api/v1/entities/organizationSettings/<setting_color_palette_id>
```
For Workspace use
``` 
   curl --request POST \
  --header "Authorization: Bearer $API_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{
    "data": {
        "type": "workspaceSetting",
        "id": "{someId}",
        "attributes": {
            "content": {
                "id": "{colorPaletteId}}",
                "type": "colorPalette"
            },
            "type": "ACTIVE_COLOR_PALETTE"
        }
    }
}' $ENDPOINT/api/v1/entities/workspaces/{workspaceId}/workspaceSettings
```

## License

Copyright (c) 2022, GoodData Corporation

This project is not intended for production usage. It’s meant to provide users exploring GoodData products with initial data and analytical objects for their evaluation or learning.

That being said, the usage of the project is not restricted beyond the requirements of the BSD 3-Clause License; please see the [LICENSE](LICENSE) for more information.
