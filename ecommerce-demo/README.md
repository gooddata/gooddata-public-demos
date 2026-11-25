# Manual provision

Credentials can be found in our [public documentation](https://www.gooddata.com/docs/cloud/getting-started/connect-data/).

For manual provision, follow this steps:

1. Copy [`http-client.private.json.template`](./http-client.private.json.template) file to [http-client.private.env.json](./http-client.private.env.json).
2. Fill in your GoodData Cloud or GoodData CN host name at [http-client.private.env.json](./http-client.private.env.json).
3. Fill in your API Token at [http-client.private.env.json](./http-client.private.env.json).
4. Open [upload.http](./upload.http) in any IntelliJ IDE.
5. In the environment drop-down select `dev`.
6. Run every request using IntelliJ tools.

Make sure to not commit your changes to `http-client.private.env.json` to Git, as it holds your API Token.

To run the same in VS Code you can use `httpYac` extension.

# Analytics as code

[`workspaces/demo/analytics`](./workspaces/demo/analytics) holds the logical data model and the analytics of the `demo`
workspace as analytics as code (AaC) YAML, one file per object. It is the source of the sample data in the GoodData
organization UI ("Sample data" on the Home page). The UI build reads these files, not `ldm.json` and
`workspaceAnalytics.json`.

## Edit the demo

Use the [`gd` CLI](https://www.npmjs.com/package/@gooddata/code-cli) or the GoodData VS Code extension.

1. Install the CLI: `npm install -g @gooddata/code-cli`.
2. Create the data source and the workspace with the first requests of [upload.http](./upload.http), up to
   "Create workspace".
3. In `workspaces/demo/analytics`, set the environment variables that [`gooddata.yaml`](./workspaces/demo/analytics/gooddata.yaml) reads:
   ```
   export GOODDATA_HOST="<your host>"
   export GOODDATA_API_TOKEN="<your API token>"
   export GOODDATA_WORKSPACE_ID="<your workspace id>"
   export GOODDATA_DATA_SOURCE_ID="gdc_ds_ecommerce_demo"
   ```
4. Run `gd deploy` to put the YAML into the workspace.
5. Change the workspace in the UI.
6. Run `gd clone` to write the workspace back to the YAML files.
7. Review the diff, and commit only the changes that you made on purpose.

Run `gd validate` before you commit. A deploy replaces the whole workspace, so an object that is missing from the YAML
is missing from the demo.

## Ship a change to the UI

The UI build does not read `master`. It reads this repository at a pinned commit, set by `DEMO_RESOURCES_GIT_REVISION`
in `modules/gdc-home-ui/module/scripts/fetch-demo-resources.sh` in the GoodData UI repository (`gdc-ui`, internal).
A merge to `master` does not change the demo in the UI.

1. Merge the change in this repository.
2. In `gdc-ui`, set `DEMO_RESOURCES_GIT_REVISION` to the merge commit, and open a pull request.

The build bundles every `.yaml` and `.yml` file in `workspaces/<workspace>/analytics`, except `gooddata.yaml`. The
build fails if a file has a YAML error, if a document has no `id` or `type`, if the UI cannot convert a document, or
if two objects of the same kind have the same `id`.

## Files that the UI does not read

- `workspaces/demo/ldm.json` and `workspaces/demo/workspaceAnalytics.json` are for the manual provision in
  [upload.http](./upload.http). A change in the YAML does not update them.
- `workspaces/demo/ldm_v2.5.0.json` and `workspaces/demo/workspaceAnalytics_aio.json` are deprecated. Other GoodData
  deployments still read them. Do not use them for new work.
