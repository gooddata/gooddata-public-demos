const assert = require('node:assert/strict');
const path = require('node:path');

const DEMO_NAME = process.argv[2];
const PANTHER_DEMO_HOST = process.env.PANTHER_DEMO_HOST;
const PANTHER_DEMO_TOKEN = process.env.PANTHER_DEMO_TOKEN;
const DS_PWD = process.env.DS_PWD;
const USER_GROUP = 'public-proxy-user-group';

assert(DEMO_NAME, 'Missing demo name CLI argument');
assert(PANTHER_DEMO_HOST, 'PANTHER_DEMO_HOST env variable is required.');
assert(PANTHER_DEMO_TOKEN, 'PANTHER_DEMO_TOKEN env variable is required.');

const { upsertEntity, upsertLayout } = require('./network')(PANTHER_DEMO_HOST, PANTHER_DEMO_TOKEN);

const main = async () => {
    const demoPath = path.resolve(__dirname, '..', DEMO_NAME);
    const workspacesManifestPath = path.resolve(demoPath, 'workspaces', 'meta.json');
    const { workspaces } = require(workspacesManifestPath);

    await deployDataSource(
        require(path.resolve(demoPath, 'dataSource', 'dataSource.json')),
        require(path.resolve(demoPath, 'dataSource', 'pdm.json'))
    );

    await Promise.all(workspaces.map(workspaceId => deployWorkspace(
        require(path.resolve(demoPath, 'workspaces', workspaceId, 'workspace.json')),
        require(path.resolve(demoPath, 'workspaces', workspaceId, 'ldm.json')),
        require(path.resolve(demoPath, 'workspaces', workspaceId, 'workspaceAnalytics.json'))
    )));
};

const deployDataSource = async (dataSource, pdm) => {
    const id = dataSource.data.id;

    // Patch data source credentials
    if (DS_PWD) {
        dataSource.data.attributes.password = DS_PWD;
    }

    await upsertEntity('/dataSources', id, dataSource);
    await upsertLayout(`/dataSources/${id}/physicalModel`, pdm);
};

const deployWorkspace = async (workspace, ldm, analytics) => {
    const id = workspace.data.id;

    await upsertEntity('/workspaces', id, workspace);
    await upsertLayout(`/workspaces/${id}/permissions`, {
        permissions: [{
            assignee: {
                id: USER_GROUP,
                type: 'userGroup',
            },
            name: 'VIEW',
        }],
    });
    await upsertLayout(`/workspaces/${id}/logicalModel`, ldm);
    await upsertLayout(`/workspaces/${id}/analyticsModel`, analytics);
};

main().then(() => {
    console.log('Deploy succeeded');
}, err => {
    console.error(err);
    process.exit(1);
});
