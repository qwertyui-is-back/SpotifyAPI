local spotify = {
	IsPlaying = false,
	AccessToken = "BQCGkQkhc4Hct12Hb4N9vE_6i4jlQoQrD77lNUoOaaF4_6-ctwwzFsVBwgUajYfoOrmsV8z-PQLNOIA79LBV6bjxzbdv2gSrRxJMVa8FyUxbFcc4QMzo67DfY2AV2BtHWE2bFzvJICiu_mv8lxY1lPXYRzZ6pZZ-YR3WZaSmQNa3pwbCgZQOB81hyQB93YimHkpm6umuvFfHzpdTybHMZ1k8IvPqK_DNASE",
	RefreshToken = "",
	ClientId = "",
	ClientSecret = ""
}

--[[ LOGIC ]]--

local httpService = game:GetService("HttpService")
local base64 = {
	chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
}

function base64.encode(input)
	local result = {}
	local padding = ""

	local remainder = #input % 3
	if remainder > 0 then
		padding = string.rep("=", 3 - remainder)
		input = input..string.rep("\0", 3 - remainder)
	end

	for i = 1, #input, 3 do
		local a = string.byte(input, i)
		local b = string.byte(input, i + 1)
		local c = string.byte(input, i + 2)

		local value1 = math.floor(a / 4)
		local value2 = ((a % 4) * 16) + math.floor(b / 16)
		local value3 = ((b % 16) * 4) + math.floor(c / 64)
		local value4 = c % 64

		result[#result + 1] = base64.chars:sub(value1 + 1, value1 + 1)
		result[#result + 1] = base64.chars:sub(value2 + 1, value2 + 1)
		result[#result + 1] = base64.chars:sub(value3 + 1, value3 + 1)
		result[#result + 1] = base64.chars:sub(value4 + 1, value4 + 1)
	end

	if padding ~= "" then
		for i = 1, #padding do
			result[#result - (i - 1)] = "="
		end
	end

	return table.concat(result)
end

local function round(num)
	return tonumber(string.format("%.2f", num))
end

local function convert(ms)
	local seconds = round(ms / 1000)
	local minutes = math.floor(seconds / 60)
	seconds = math.floor(seconds - (minutes * 60))
	if #tostring(seconds) < 2 then
		seconds = string.format("0%d", seconds)
	end
	return string.format("%s:%s", minutes, seconds)
end

local function getasync(args)
	local httpFunc = http and http.request or httpService.RequestAsync
	return http and http.request(args) or httpService:RequestAsync(args)
end

local function request(url, method)
	local heads = {
		Authorization = "Bearer "..spotify.AccessToken
	}
	local USEBODY = method == "POST" or method == "PUT"
	local data = getasync({
		Url = "https://api.spotify.com/v1/"..url,
		Method = method or "GET",
		Headers = heads,
		Body = USEBODY and "" or nil
	})
	return data
end

--[[ FUNCTIONS ]]--

--[[
Gets the authorization url for the user to login to their account.

Returns a string of the url.
]]
function spotify:GenerateURL(scopes: {string}): string
	return `https://accounts.spotify.com/authorize?client_id={spotify.ClientId}&response_type=code&scope={table.concat(scopes, "%20")}&redirect_uri={spotify.RedirectUri:gsub(":", "%%3A")}`
end

--[[
Handles the code from GenerateURL.

Creates an access token that expires in an hour, and returns a refresh token.
]]
function spotify:HandleCode(code: string): string
	local encoded = base64.encode(spotify.ClientId..":"..spotify.ClientSecret)
	local data = getasync({
		Url = "https://accounts.spotify.com/api/token",
		Method = "POST",
		Headers = {
			Authorization = "Basic "..encoded,
			["Content-Type"] = "application/x-www-form-urlencoded"
		},
		Body = "grant_type=authorization_code&code="..code.."&redirect_uri="..spotify.RedirectUri
	})
	local update = httpService:JSONDecode(data.Body)
	spotify.AccessToken = update.access_token
	spotify.RefreshToken = update.refresh_token
	return update.refresh_token
end

--[[
Updates the local Spotify access token.

Should only be called if the original access token is invalid, or if the token has expired.
]]
function spotify:UpdateToken(token: string): ()
	local encoded = base64.encode(spotify.ClientId..":"..spotify.ClientSecret)
	local data = getasync({
		Url = "https://accounts.spotify.com/api/token",
		Method = "POST",
		Headers = {
			Authorization = "Basic "..encoded,
			["Content-Type"] = "application/x-www-form-urlencoded"
		},
		Body = "grant_type=refresh_token&refresh_token="..token
	})

	if data.StatusCode == 200 then
		spotify.RefreshToken = token
		spotify.AccessToken = httpService:JSONDecode(data.Body).access_token
	elseif data.StatusCode == 400 then
		error("client id or secret invalid")
	else
		error(httpService:JSONDecode(data.Body).error)
	end
end

--[[
Gets the current song playing on the user's account.

Returns a table with the following data:
- Name (string): The name of the current song.
- Artist (string): The name of the artist for the current song.
- Cover (string): The cover art URL for the current song.
- Album (string): The name of the album for the current song.
- Length (string): The length of the current song in minutes.
- Progress (string): The current progress of the current song in minutes.
- SongId (string): The Spotify ID of the current song.
- Playing (boolean): Whether the current song is playing or not.
]]
function spotify:GetCurrentSong(): {}
	if spotify.RefreshToken == "" then
		return error("refresh token expected, got nil")
	end
	local data = request("me/player/currently-playing")
	if data.StatusCode == 204 then return "play song first" end
	if data.StatusCode == 200 then
		local song = httpService:JSONDecode(data.Body)

		local artists = {}
		for i, v in song.item.artists do
			table.insert(artists, v.name)
		end

		local artist = table.concat(artists, ", ")

		spotify.IsPlaying = song.is_playing

		return {
			Name = song.item.name,
			Artist = artist,
			Cover = song.item.album.images[2].url,
			Album = song.item.album.name,
			Length = convert(song.item.duration_ms),
			Progress = convert(song.progress_ms),
			SongId = song.item.id,
			Playing = song.is_playing
		}
	elseif data.StatusCode == 401 then
		error(httpService:JSONDecode(data.Body).error.message)
	else
		error(httpService:JSONDecode(data.Body).error.message)
	end
end

--[[
Play or pause the current song.

-[ PREMIUM FEATURE ]-
-[ This requires Spotify Premium! ]-

Either put true or false, or leave blank to toggle.
]]
function spotify:EditPlayback(playback: string): ()
	if spotify.RefreshToken == "" then
		return error("refresh token expected, got nil")
	end
	playback = playback ~= nil and playback or not spotify.IsPlaying
	local playing = playback and "play" or "pause"
	local data = request("me/player/"..playing, "PUT")
	if data.StatusCode == 204 then
		spotify.IsPlaying = playback
	elseif data.StatusCode == 403 then
		error("premium account expected, got free account")
	else
		error("Error editing playback "..httpService:JSONDecode(data.Body).error.message)
	end
end

--[[
Changes the currently playing song to the given Song ID.

-[ PREMIUM FEATURE ]-
-[ This requires Spotify Premium! ]-

The Song ID must be a string.
]]
function spotify:Play(songId: string): ()
	if spotify.RefreshToken == "" then
		return error("refresh token expected, got nil")
	end
	local data = request("me/player/play", "PUT", {
		body = httpService:JSONEncode({
			uris = {
				"spotify:track:"..songId
			}
		})
	})
	if data.StatusCode == 204 then
		-- changed
	elseif data.StatusCode == 403 then
		error("premium account expected, got free account")
	else
		error("Error changing song "..httpService:JSONDecode(data.Body).error.message)
	end
end

--[[
Skips the current song.

-[ PREMIUM FEATURE ]-
-[ This requires Spotify Premium! ]-

]]
function spotify:SkipSong(amount): ()
	if spotify.RefreshToken == "" then
		return error("refresh token expected, got nil")
	end
	amount = amount or 1
	local mode = amount > 0 and "next" or "previous"
	for i = 0, amount do
		local data = request("me/player/"..mode, "POST")
		if data.StatusCode == 204 then
			-- skipped
		elseif data.StatusCode == 403 then
			error("premium account expected, got free account")
		else
			error("Error skipping song "..httpService:JSONDecode(data.Body).error.message)
		end
	end
end

return spotify
