# 🤓 FiveM Logger by Fivemerr

A logging resource for your FiveM server that logs directly to [Fivemerr's](https://fivemerr.com/) api. 

# Requirements

- FXServer With at least build: `5562`
- [screenshot-basic](https://github.com/citizenfx/screenshot-basic)
- [ox_lib](https://github.com/overextended/ox_lib)

# Installation
1. Add your Fivemer Logs API token to `server.cfg`
```
# Fivemerr Api Token
set fivemerr:apiToken "token"
```

2. Configure your framework or standalone on `shared > config.lua` line 8. 

# Features

- Chat Logs
- Join Logs
- Spawn Logs (Based on specified framework)
- Leave Logs
- Damage Logs
- Death Logs
- Weapon Logs
- Resource Logs
- Explosion Logs
- TxAdmin Logs
- Screenshot Logs
- Framework Logs (Only QB is supported at this moment)

# Preview
![image](https://github.com/user-attachments/assets/7d322f05-39ba-4dea-b52a-db7b7f8e1d13)


# Custom Logging

You may use `fm-logs` to leverage custom reporting to Fivemerr by using the following export function:

```
-- Example of a createLog function with full detail
exports['fm-logs']:createLog({
    LogType = "Player", -- The log type
    Message = "Player action here", -- The message of the log
    Level = "info", -- The level of the log (can be filtered on Fivemerr) (info by default)
    Resource = "script-name", -- Resource where the log is coming from (If not provided, `fm-logs` will be set by default)
    Source = 1, -- Server id for player (Required for Player Attributes to be pulled)
    Metadata = {} -- Custom attributes to be added
}, { Screenshot = true })
```

The export can be used on both server and client sides.

### `CreateLog` Parameters

1. Data : Required (Refer to example above) - The data for the log to be created
2. Options : Optional (Refer to example above) - Options for log

**Note:** To use `options.Screenshot`, `data.Source` must be provided. If you set `options.Screenshot` to `true` but do not pass a source, a screenshot will NOT be taken.

### Simple Usage Example of Export

```
exports['fm-logs']:createLog({
    LogType = "Custom",
    Resource = "my-custom-script",
    Message = "The log message here",
    Metadata = {
        foo = "bar"
    }
})
```

# Framework Support 

This logger does not require a framework, however, if you use QBCore or ESX, you can set these in the config to display the player's character name in the logs on Fivemerr. Setting a framework will also enable the "playerConnected" log in the spawn logs as it will listen to the player loaded event based on the framework specified.

```
Framework = "qb", -- "qb" | "esx" | "standalone"
```

If you do not use a framework, simply set this to "standalone".

### QB Core

We now support `qb-logs` without having to alter `qb-smallresources` directly. To enable this, set the following configuration variable values:

```
Config.Framework = "qb"
Config.Logs.Framework = true
```

# Credits 
* [iratetech](https://github.com/ir8scripts)
* [JD_logsV3](https://github.com/JohnnyS/JD_logsV3)
