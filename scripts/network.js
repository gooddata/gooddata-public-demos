const assert = require('node:assert/strict');
const path = require('node:path');
const https = require('node:https');

module.exports = (host, token) => ({
    upsertEntity: async (basePath, id, data) => {
        const postUrl = new URL(path.join('/api/v1/entities', basePath), host);
        const getPutUrl = new URL(path.join('/api/v1/entities', basePath, id), host);
        const mime = 'application/vnd.gooddata.api+json';

        let statusCode = await request(getPutUrl, token, mime);
        assert(statusCode < 300 || statusCode === 404, `Failed to read ${getPutUrl.href}, status code ${statusCode}`);

        const method = statusCode === 404 ? 'POST' : 'PUT';
        const url = statusCode === 404 ? postUrl : getPutUrl;

        statusCode = await request(url, token, mime, method, data);
        assert(statusCode < 300, `Failed to update ${getPutUrl.href}, status code ${statusCode}`);
    },
    upsertLayout: async (basePath, data) => {
        const putUrl = new URL(path.join('/api/v1/layout', basePath), host);
        const statusCode = await request(putUrl, token, 'application/json', 'PUT', data);
        assert(statusCode < 300, `Failed to update ${putUrl.href}, status code ${statusCode}`);
    }
});

const request = (path, token, contentType, method = 'GET', payload = null) => {
    return new Promise((resolve, reject) => {
        const req = https.request(path, {method, headers: {
            'Content-Type': contentType,
            'Accept': contentType,
            'Authorization': `Bearer ${token}`
        }}, res => {
            res.on('end', () => {
                assert(res.complete, 'Request interrupted');
                resolve(res.statusCode);
            });
            res.on('error', error => {reject(error)});
            res.resume();
        });

        if (payload) {
            req.write(JSON.stringify(payload));
        }

        req.end();
    });
}
