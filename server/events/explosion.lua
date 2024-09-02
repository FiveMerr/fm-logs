-- Defined explosion types
local explosionTypes = {'GRENADE', 'GRENADELAUNCHER', 'STICKYBOMB', 'MOLOTOV', 'ROCKET', 'TANKSHELL', 'HI_OCTANE',
                        'CAR', 'PLANE', 'PETROL_PUMP', 'BIKE', 'DIR_STEAM', 'DIR_FLAME', 'DIR_GAS_CANISTER', 'BOAT',
                        'SHIP_DESTROY', 'TRUCK', 'BULLET', 'SMOKEGRENADELAUNCHER', 'SMOKEGRENADE', 'BZGAS', 'FLARE',
                        'GAS_CANISTER', 'EXTINGUISHER', 'PROGRAMMABLEAR', 'TRAIN', 'BARREL', 'PROPANE', 'BLIMP',
                        'DIR_FLAME_EXPLODE', 'TANKER', 'PLANE_ROCKET', 'VEHICLE_BULLET', 'GAS_TANK', 'BIRD_CRAP',
                        'RAILGUN', 'BLIMP2', 'FIREWORK', 'SNOWBALL', 'PROXMINE', 'VALKYRIE_CANNON', 'AIR_DEFENCE',
                        'PIPEBOMB', 'VEHICLEMINE', 'EXPLOSIVEAMMO', 'APCSHELL', 'BOMB_CLUSTER', 'BOMB_GAS',
                        'BOMB_INCENDIARY', 'BOMB_STANDARD', 'TORPEDO', 'TORPEDO_UNDERWATER', 'BOMBUSHKA_CANNON',
                        'BOMB_CLUSTER_SECONDARY', 'HUNTER_BARRAGE', 'HUNTER_CANNON', 'ROGUE_CANNON', 'MINE_UNDERWATER',
                        'ORBITAL_CANNON', 'BOMB_STANDARD_WIDE', 'EXPLOSIVEAMMO_SHOTGUN', 'OPPRESSOR2_CANNON',
                        'MORTAR_KINETIC', 'VEHICLEMINE_KINETIC', 'VEHICLEMINE_EMP', 'VEHICLEMINE_SPIKE',
                        'VEHICLEMINE_SLICK', 'VEHICLEMINE_TAR', 'SCRIPT_DRONE', 'RAYGUN', 'BURIEDMINE', 'SCRIPT_MISSIL'}

-- Defined explosion names
local explosionNames = {
    ['GRENADE'] = 'Grenade',
    ['GRENADELAUNCHER'] = 'Grenade Launcher',
    ['STICKYBOMB'] = 'Sticky Bomb',
    ['MOLOTOV'] = 'Molotov',
    ['ROCKET'] = 'Rocket',
    ['TANKSHELL'] = 'Tank Shell',
    ['HI_OCTANE'] = 'HI_OCTANE',
    ['CAR'] = 'Vehicle: Car',
    ['PLANE'] = 'vehicle: Plane',
    ['PETROL_PUMP'] = 'Petrol Pump',
    ['BIKE'] = 'Vehicle: Bike',
    ['DIR_STEAM'] = 'DIR_STEAM',
    ['DIR_FLAME'] = 'DIR_FLAME',
    ['DIR_GAS_CANISTER'] = 'Gas Canister',
    ['GAS_CANISTER'] = 'Gas Canister',
    ['BOAT'] = 'Vehicle: Boat',
    ['SHIP_DESTROY'] = 'Vehicle: Ship',
    ['TRUCK'] = 'Vehicle: Truck',
    ['BULLET'] = 'Exploding Bullet',
    ['SMOKEGRENADELAUNCHER'] = 'Smoke Grenade (Launcher)',
    ['SMOKEGRENADE'] = 'Smoke Grenade',
    ['BZGAS'] = 'BZ Gas',
    ['FLARE'] = 'Flare',
    ['EXTINGUISHER'] = 'Fire Extinguiser',
    ['PROGRAMMABLEAR'] = 'PROGRAMMABLEAR',
    ['TRAIN'] = 'Vehicle: Train',
    ['BARREL'] = 'Barrel',
    ['PROPANE'] = 'Propane',
    ['BLIMP'] = 'Blimp',
    ['DIR_FLAME_EXPLODE'] = 'DIR_FLAME_EXPLODE',
    ['TANKER'] = 'Vehicle: Tanker',
    ['PLANE_ROCKET'] = 'Plane Rocket',
    ['VEHICLE_BULLET'] = 'Vehicle Bullet',
    ['GAS_TANK'] = 'Gas Tank',
    ['BIRD_CRAP'] = 'BIRD_CRAP',
    ['RAILGUN'] = 'Railgun',
    ['BLIMP2'] = 'BLIMP2',
    ['FIREWORK'] = 'Fireworks',
    ['SNOWBALL'] = 'Snowball',
    ['PROXMINE'] = 'Proximity Mine',
    ['VALKYRIE_CANNON'] = 'Valkyrie Cannon',
    ['AIR_DEFENCE'] = 'Air Defence',
    ['PIPEBOMB'] = 'Pipe Bomb',
    ['VEHICLEMINE'] = 'Vehicle Mine',
    ['EXPLOSIVEAMMO'] = 'Explosive Ammo',
    ['APCSHELL'] = 'APC Shell',
    ['BOMB_CLUSTER'] = 'Bomb Cluster',
    ['BOMB_GAS'] = 'Bomb Gas',
    ['BOMB_INCENDIARY'] = 'Bomb Incendiary',
    ['BOMB_STANDARD'] = 'Bomb',
    ['TORPEDO'] = 'Torpedo',
    ['TORPEDO_UNDERWATER'] = 'Torpedo Under Water',
    ['BOMBUSHKA_CANNON'] = 'BOMBUSHKA_CANNON',
    ['BOMB_CLUSTER_SECONDARY'] = 'BOMB_CLUSTER_SECONDARY',
    ['HUNTER_BARRAGE'] = 'HUNTER_BARRAGE',
    ['HUNTER_CANNON'] = 'HUNTER_CANNON',
    ['ROGUE_CANNON'] = 'ROGUE_CANNON',
    ['MINE_UNDERWATER'] = 'MINE_UNDERWATER',
    ['ORBITAL_CANNON'] = 'ORBITAL_CANNON',
    ['BOMB_STANDARD_WIDE'] = 'BOMB_STANDARD_WIDE',
    ['EXPLOSIVEAMMO_SHOTGUN'] = 'EXPLOSIVEAMMO_SHOTGUN',
    ['OPPRESSOR2_CANNON'] = 'OPPRESSOR2_CANNON',
    ['MORTAR_KINETIC'] = 'MORTAR_KINETIC',
    ['VEHICLEMINE_KINETIC'] = 'VEHICLEMINE_KINETIC',
    ['VEHICLEMINE_EMP'] = 'VEHICLEMINE_EMP',
    ['VEHICLEMINE_SPIKE'] = 'VEHICLEMINE_SPIKE',
    ['VEHICLEMINE_SLICK'] = 'VEHICLEMINE_SLICK',
    ['VEHICLEMINE_TAR'] = 'VEHICLEMINE_TAR',
    ['SCRIPT_DRONE'] = 'SCRIPT_DRONE',
    ['RAYGUN'] = 'RAYGUN',
    ['BURIEDMINE'] = 'BURIEDMINE',
    ['SCRIPT_MISSIL'] = 'SCRIPT_MISSIL'
}

-- Log for when an explosion event is triggered
AddEventHandler('explosionEvent', function(source, ev)
    local src = source

    -- If this log is not enabled, just return early
    if not Config.Logs.Explosion then return end

    -- Check if this explosion type is ignored
    if not Logger.TableHasValue(Config.Logs.ExplosionsNotLogged, explosionTypes[ev.explosionType + 1]) then
        Logger.CreateLog({
            LogType = "Explosion",
            Message = Language.Locale('explosion', {
                name = Framework.Server.GetPlayerName(src)
            }),
            Source = src,
            Metadata = {
                Name = Framework.Server.GetPlayerName(src),
                Type = Language.Locale(explosionTypes[ev.explosionType + 1]) or explosionNames[explosionTypes[ev.explosionType + 1]]
            }
        })
    end
end)
