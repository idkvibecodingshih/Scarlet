if getgenv().__AVERION_CLIENT_LOADED then
    return
end

getgenv().__AVERION_CLIENT_LOADED = true

local Players =
    game:GetService("Players")

local HttpService =
    game:GetService("HttpService")

local RunService =
    game:GetService("RunService")

local LocalPlayer =
    Players.LocalPlayer

local ENDPOINT =
    "http://127.0.0.1:8123/rest/v1/players"

print("[AVERION] Client loaded")

local function getCharacterData(player)

    local character =
        player.Character

    local humanoid =
        character
        and
        character:FindFirstChildOfClass(
            "Humanoid"
        )

    local root =
        character
        and
        character:FindFirstChild(
            "HumanoidRootPart"
        )

    return {

        name =
            player.Name,

        display_name =
            player.DisplayName,

        user_id =
            player.UserId,

        team =
            player.Team
            and
            player.Team.Name
            or
            "None",

        health =
            humanoid
            and
            humanoid.Health
            or
            0,

        max_health =
            humanoid
            and
            humanoid.MaxHealth
            or
            0,

        walkspeed =
            humanoid
            and
            humanoid.WalkSpeed
            or
            0,

        jumppower =
            humanoid
            and
            humanoid.JumpPower
            or
            0,

        position =
            root and {

                x = root.Position.X,
                y = root.Position.Y,
                z = root.Position.Z

            } or {

                x = 0,
                y = 0,
                z = 0
            }
    }
end

local function buildPayload()

    local players = {}

    for _, player in ipairs(
        Players:GetPlayers()
    ) do

        table.insert(
            players,
            getCharacterData(player)
        )
    end

    local localplayer =
        getCharacterData(
            LocalPlayer
        )

    local payload = {

        players =
            players,

        localplayer =
            localplayer,

        server = {

            place_id =
                game.PlaceId,

            job_id =
                game.JobId,

            player_count =
                #Players:GetPlayers(),

            max_players =
                Players.MaxPlayers
        }
    }

    return payload
end

local sending = false

local function sendUpdate()

    if sending then
        return
    end

    sending = true

    local success, err =
        pcall(function()

            local payload =
                buildPayload()

            request({

                Url = ENDPOINT,

                Method = "POST",

                Headers = {
                    ["Content-Type"] =
                        "application/json"
                },

                Body =
                    HttpService:JSONEncode(
                        payload
                    )
            })
        end)

    if not success then

        warn(
            "[AVERION CLIENT ERROR]:",
            err
        )
    end

    sending = false
end

task.spawn(function()

    while task.wait(1) do

        pcall(sendUpdate)
    end
end)

Players.PlayerAdded:Connect(function()

    task.wait(0.5)

    pcall(sendUpdate)
end)

Players.PlayerRemoving:Connect(function()

    task.wait(0.5)

    pcall(sendUpdate)
end)

LocalPlayer.CharacterAdded:Connect(function()

    task.wait(1)

    pcall(sendUpdate)
end)

RunService.Heartbeat:Connect(function()

    if tick() % 5 < 0.03 then

        pcall(sendUpdate)
    end
end)
