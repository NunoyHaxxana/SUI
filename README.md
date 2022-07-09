# Sui Node Setup

### Sui Requirements
>:black_square_button: OS Ubuntu 18.04 or 20.04 <br>
>:black_square_button: 2 CPUs<br>
>:black_square_button: 8GB RAM<br>
>:black_square_button: 50GB Storage<br>
>:black_square_button: Need Super user or root for run this script.<br>

## Official documentation:
- Run a Sui Fullnode : https://github.com/MystenLabs/sui/blob/main/doc/src/build/fullnode.md
- Node health monitor : https://node.sui.zvalid.com/





# Set up Sui full node with auto script.
## Clone and Install Scripts

```
wget -q -O sui_setup.sh https://raw.githubusercontent.com/NunoyHaxxana/SUI/main/sui.sh && chmod +x sui_setup.sh && sudo /bin/bash sui_setup.sh
```


## Check Node Status 
```
curl -s -X POST http://127.0.0.1:9000 -H 'Content-Type: application/json' -d '{ "jsonrpc":"2.0", "method":"rpc.discover","id":1}' | jq .result.info
```


Send a request, the result should be something like this:
```
{
  "title": "Sui JSON-RPC",
  "description": "Sui JSON-RPC API for interaction with the Sui network gateway.",
  "contact": {
    "name": "Mysten Labs",
    "url": "https://mystenlabs.com",
    "email": "build@mystenlabs.com"
  },
  "license": {
    "name": "Apache-2.0",
    "url": "https://raw.githubusercontent.com/MystenLabs/sui/main/LICENSE"
  },
  "version": "0.1.0"
}
```


## Register your node on discord
After fisnish install Sui node, You have register your node in the Sui Discord:

https://discord.gg/kqfQbYjUGq
