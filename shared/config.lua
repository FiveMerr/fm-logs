Config = {

    -- Language to use
    Language = "en",

    -- Framework for logging player names
    -- Standalone uses server player name
    Framework = "standalone", -- "qb" | "esx" | "standalone"

    -- Event prefixes
    ClientEventPrefix = GetCurrentResourceName() .. ":Client:",
    ServerEventPrefix = GetCurrentResourceName() .. ":Server:",

    -- Command configuration
    Commands = {

        -- The command for capturing a screenshot of a player's screen
        Screenshot = "screenshot",

        -- Permissions for commands
        Permissions = { "admin" }
    },

    -- Log settings
    Logs = {

        -- Log enabling settings
        Weapon = true, -- Shots fired except for excluded weapons
        Explosion = true, -- Explosion events except for excluded explosions
        Damage = true, -- Player damage
        Death = true, -- Player death
        Player = true, -- Player events (Join, leave, etc)
        Chat = true, -- Chat message events
        Resource = true, -- Resource start / stop
        System = true, -- System logs
        TxAdmin = true, -- TxAdmin logs
        Screenshot = true, -- Screenshot logs
        Framework = false, -- Will log framework logs if applicable

        -- The following attributes will be included in 
        -- the log meta data if true.
        PlayerAttributes = {

            -- Player attributes
            PlayerId = true,
            Postals = true,
            PlayerHealth = true,
            PlayerArmor = true,
            PlayerPing = true,

            -- Player IP Logging
            Ip = true,

            -- Player identifiers
            DiscordId = true,
            SteamId = true,
            License = true,
        },

        -- Weapon exclusions
        WeaponsNotLogged = {
            "WEAPON_SNOWBALL",
            "WEAPON_FIREEXTINGUISHER",
            "WEAPON_PETROLCAN"
        },

        -- Explosion exclusions
        ExplosionsNotLogged = {},
    }
}