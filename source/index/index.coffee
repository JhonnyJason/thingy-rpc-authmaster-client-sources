############################################################
#region imports
import { RPCPostClient } from "thingy-post-rpc-client"

#endregion

############################################################
export class RPCAuthMasterClient extends RPCPostClient
    constructor: (o) ->
        super(o)

    ########################################################
    addClient: (clientPublicKey) ->
        authType = "masterSignature" 
        args = { clientPublicKey }
        func = "addClientToServe"
        return @doRPC(func, args, authType)

    removeClient: (clientPublicKey) ->
        authType = "masterSignature" 
        args = { clientPublicKey }
        func = "removeClientToServe"
        return @doRPC(func, args, authType)

    getClients: ->
        authType = "masterSignature" 
        args = {  }
        func = "getClientsToServe"
        return @doRPC(func, args, authType)

