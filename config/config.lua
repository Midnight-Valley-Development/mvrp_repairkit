local seconds = 1000 -- No touchy
Config = {} -- No touchy
Globals = {} -- No touchy

Config.Debug = true -- Enable debug messages
Config.Cooldown = 3 -- Delay between repairs in seconds

Config.RepairKits = {
    {
        item = 'repairkit', -- Inventory item name
        usetime = 10 * seconds, -- Time to repair
        -- allowedJobsTypes = { -- Allowed job types to repair with this item
        --     mechanic = true -- Based on job type NOT job NAME
        -- },
        repairParts = { -- Parts of the vehicle that will be repaired. Can leave out if not used
            wheels = false, -- Fix all wheels
            body = true, -- Fix body damage
            engine = false, -- Fix engine damage
            cleaning = false, -- Cleans vehicle
            anticlean = false -- Dirty vehicle
        },
        anim = { -- Animation stuff
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            lib = 'machinic_loop_mechandplayer'
        }
    },
    {
        item = 'enginerepairkit',
        usetime = 15 * seconds,
        repairParts = {
            engine = true,
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            lib = 'machinic_loop_mechandplayer'
        }
    },
    {
        item = 'tirerepairkit',
        usetime = 10 * seconds,
        repairParts = {
            wheels = true,
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            lib = 'machinic_loop_mechandplayer'
        }
    },
    {
        item = 'cleaningkit',
        usetime = 5 * seconds,
        repairParts = {
            cleaning = true
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            lib = 'machinic_loop_mechandplayer'
        }
    },
    {
        item = 'advancedrepairkit',
        usetime = 20 * seconds,
        allowedJobsTypes = {
            mechanic = true
        },
        repairParts = {
            wheels = true,
            body = true,
            engine = true,
            cleaning = true
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            lib = 'machinic_loop_mechandplayer'
        }
    },
}

-- OX_LIB at the moment. Expansion later perhaps
-- TBH I should move all the stuff below here to functions or something like that... Oh well, have fun, don't fuck it up
-- TextUI stuff. Probably don't touch... unless you know what you're doing.
Config.TextUI = function(action, msg)
    if action == 'open' then
        lib.showTextUI(msg)
    elseif action == 'close' then
        lib.hideTextUI()
    end
end

-- Notification stuff. Probably don't touch... unless you know what you're doing.
function ShowNotification(message, notifyType)
    lib.notify({
        description = message,
        type = notifyType,
        position = 'top-right'
    })
end