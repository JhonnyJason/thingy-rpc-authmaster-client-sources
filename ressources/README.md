# thingy-rcp-authmaster-client


## Background
In the Thingy Eco System we simplified the authentication concept. 
A client is identified by it's `publicKey`  = `clientId` and either the client is authorized to use the service, or it is not.

For most Services we need the capability to change who is authorized and who not on-the-fly.
For this reason we have the `AuthMaster`  who holds the `masterKey` for the service and may use these specific functions:

- `addClient`
- `removeClient`
- `getClients`

And this is the library which implements exactly these functions as RPC calls to the respective service.


## Usage
### Requirements
We already rely on fetch in nodejs
- nodejs >= 19
- esm importablitly

### Current Functionality
```coffeescript
import { RPCPostClient } from "thingy-post-rpc-client"

options = {
    serverURL: "https://myservice.myserver.tld/thingy-post-rpc", # required
    serverId: "..." # required - verify the right server!
    serverContext: "..." # optional - default "thingy-rpc-post-connection"
    secretKeyHex: "..." # required
    publicKeyHex: "..." # optional - will be calculated from secretKeyHex
    name: "..." # optional - default rpc-client
    anonymousToken : "" # optional - default null
    publicToken: "" # optional - default null

}

## construct client
rpcClient = new RPCPostClient(options)


## doRPC Request
rpcClient.doRPC(func, args, authType)
rpcClient.doRPC(String, Object, String)

## getters
serverURL = rpcClient.getServerURL()
secretKeyHex = rpcClient.getSecretKey()
serverIdHex = await rpcClient.getServerId()
publicKeyHex = await rpcClient.getPublicKey()

## "setters"
rpcClient.updateKeys(newSecretKey, newPublicKey)
rpcClient.updateKeys( StringHex, StringHex )

rpcClient.updateServer(newServerURL, newServerId, newServerContext)
rpcClient.updateServer( String, String, String )

```

### doRPC
This is the core function.
```coffeescript
rpcClient.doRPC(func, args, authType)
```

Here `func` is the function name or in JSON-RPC terms then `method`.
The `args` are the JSON arguments for this function equivalent to the JSON-RPC `params`.
The `authType` is the special part here. The `thingy-post-rpc-client` will create the correct `auth` object according to this `authType`.

Available `authTypes` are:
- `none` [details here](https://hackmd.io/dZ_QRu5YR2eHGDeZb-lYcg?vie#None)
- `anonymous` [details here](https://hackmd.io/dZ_QRu5YR2eHGDeZb-lYcg?vie#Anonymous)
- `publicAccess` [details here](https://hackmd.io/dZ_QRu5YR2eHGDeZb-lYcg?vie#Non-Anonymous)
- `tokenSimple` [details here](https://hackmd.io/dZ_QRu5YR2eHGDeZb-lYcg?vie#Simple-Token)
- `authCodeSHA2` [details here](https://hackmd.io/dZ_QRu5YR2eHGDeZb-lYcg?vie#AuthCode-SHA2)
- `signature` [details here](https://hackmd.io/dZ_QRu5YR2eHGDeZb-lYcg?vie#Signatures)
- `clientSignature` [details here](https://hackmd.io/dZ_QRu5YR2eHGDeZb-lYcg?vie#Signatures)
- `masterSignature` [details here](https://hackmd.io/dZ_QRu5YR2eHGDeZb-lYcg?vie#Signatures)

According to this `authType` also the response is being authenticated. Throwing an `ResponseAuthError` if the `auth` of the response request does not match.


### Sessions
Some `authType`s result in a session. 

Namely these are:
- `tokenSimple`
- `authCodeSHA2`

For each of these options, the `RPCPostClient` will start a new session explicitly if we donot have a session of that `authType` yet.

Explicit Session start is calling the `startSession` function on the server via `clientSignature`, providing as arguments `type` = `authType`, `name` and`clientId`.

Note: one RPCPostClient may only have 1 session and this is either of these types.

#### Multiple Sessions
Generally one `RPCPostClient` only maintains one session per `authType`.
For multiple sessions of the same `authType` and `clientId` you can use multiple `RPCPostClient`s. In this situation the option `name` is important as the server should use the `name` to distinguish these sessions. Using the same `name` and `clientId` would result in overwriting previous session information.


# Further steps

- fix bugs
- add more features


All sorts of inputs are welcome, thanks!

---

# License
[Unlicense JhonnyJason style](https://hackmd.io/nCpLO3gxRlSmKVG3Zxy2hA?view)
