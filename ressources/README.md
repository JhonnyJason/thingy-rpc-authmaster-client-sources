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

It is an instance of [thingy-post-rpc-client](https://www.npmjs.com/package/thingy-post-rpc-client).

## Usage
### Requirements
We already rely on fetch in nodejs
- nodejs >= 19
- esm importablitly

### Current Functionality
```coffeescript
import { RPCAuthMasterClient } from "thingy-rpc-authmaster-client"

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
authMasterClient = new RPCAuthMasterClient(options)


## Manage Your Authorized Clients
await authMasterClient.addClient(publicKey) -> true
await authMasterClient.addClient(StringHex) -> true

await authMasterClient.removeClient(publicKey) -> true
await authMasterClient.removeClient(StringHex) -> true

await authMasterClient.getClients() -> [ pubHex1, pubHex2, ... ]

```

### Signatures
All these functions are authenticated by signatures of the services MasterKey.
Using the RPC authentication type of `masterSignatuer`.


# Further steps

- fix bugs
- add more features


All sorts of inputs are welcome, thanks!

---

# License
[Unlicense JhonnyJason style](https://hackmd.io/nCpLO3gxRlSmKVG3Zxy2hA?view)
