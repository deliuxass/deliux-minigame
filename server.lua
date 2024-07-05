local config = {
    prizeAmount = 10000,
    discordWebhook = 'https://canary.discord.com/api/webhooks/1258855492848062575/kVoyX1zramSWXIkkkVZcG-7gIRpL0YIiZNba-GwW2RnQLE_WZ_LGVyON0UZ2zHe4UrEH',
    debug = true
}

local function awardDailyPrize()
    local xPlayers = ESX.GetPlayers()

    if #xPlayers > 0 then
        local winnerId = xPlayers[math.random(1, #xPlayers)]
        local xWinner = ESX.GetPlayerFromId(winnerId)
        local steamName = GetPlayerName(winnerId)

        xWinner.addMoney(config.prizeAmount)

        local message = {
            username = 'Laimės ratas',
            embeds = {{
                title = 'Laimės ratas',
                description = string.format('Buvo išrinktas žaidėjas **%s**, ir jis laimėjo $**%d**!', steamName, config.prizeAmount),
                color = 15158332,
                image = {
                    url = 'https://i.imgur.com/CRCEELk.png'
                },
                footer = {
                    text = 'Kitas žaidimas vyks rytoj 18:00 valandą.'
                }
            }}
        }

        PerformHttpRequest(config.discordWebhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })

        print(string.format('Laimėjo $%d žaidėjas %s', config.prizeAmount, steamName))
    else
        local message = {
            username = 'Laimės ratas',
            embeds = {{
                title = 'Laimės ratas',
                description = 'Serverije trūko dar 1, kad būtų išrinktas laimėtojas. Kitas žaidimas vyks rytoj 18:00 valandą.',
                color = 15158332,
                image = {
                    url = 'https://i.imgur.com/CRCEELk.png'
                }
            }}
        }

        PerformHttpRequest(config.discordWebhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })

        print('Nerasta jokiu žaidėjų.')
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        local hour = tonumber(os.date("%H"))
        local minute = tonumber(os.date("%M"))

        if hour == 18 and minute == 0 then
            awardDailyPrize()
        end
    end
end)

-- ŠITA KOMANDA TIESIOG NAUDOKITE CONSOLEJ.
RegisterCommand('debugdailyprize', function(source, args, rawCommand)
    if source == 0 or IsPlayerAceAllowed(source, "command.debugdailyprize") then
        awardDailyPrize()
    else
        print('Neturi privilegijų.')
    end
end, false)