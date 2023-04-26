# Manual provision

For manual provision, follow this steps:

1. Copy [`http-client.private.json.template`](./http-client.private.json.template) file to [http-client.private.env.json](./http-client.private.env.json).
2. Fill in your GoodData Cloud or GoodData CN host name at [http-client.private.env.json](./http-client.private.env.json).
3. Fill in your API Token at [http-client.private.env.json](./http-client.private.env.json).
4. Open [upload.http](./upload.http) in any IntelliJ IDE.
5. In the environment drop-down select `dev`.
6. Run every request using IntelliJ tools.

Make sure to not commit your changes to `http-client.private.env.json` to Git, as it holds your API Token.

To run the same in VS Code you can use `httpYac` extension.
