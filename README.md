# SpotifyAPI
### An API used for roblox to implement the Spotify API.

# Features

- Update the Spotify token
- Get currently playing song data
- Pause & Play music

# Instructions

In order for this to work, you're going to need to enable 'Allow Http Requests' in your games ssttingd.

First, make a folder in your Roblox project. You can name the folder whatever.
Then, go inside [Spotify.lua](https://github.com/qwertyui-is-back/SpotifyAPI/blob/main/Spotify.lua), and copy the code.
You will then want to make a file in the folder called 'Spotify', and paste the code.

You are now finished, and can use the Spotify API!

# Examples
## Update access token
```lua
local spotify = require(game:GetService("ReplicatedStorage").Folder.Spotify)
spotify.ClientId = CLIENT_ID -- From Spotify API Dashboard
spotify.ClientSecret = CLIENT_SECRET -- From Spotify API Dashboard
spotify.RefreshToken = TOKEN -- Tutorial coming soon!
spotify:UpdateToken(spotify.RefreshToken)
print(spotify.AccessToken)
```
## Get currently playing song
```lua
local spotify = require(game:GetService("ReplicatedStorage").Folder.Spotify)
local song = spotify:GetCurrentSong()
print(song.Album, song.Name, song.Artist, song.Duration, song.DurationMS, song.Progress, song.ProgressMS) -- GNX tv off Kendrick Lamar 3:41 221000 0:47 47000
```
## Is song playing
```lua
local spotify = require(game:GetService("ReplicatedStorage").Folder.Spotify)
print(spotify.IsPlaying) -- true/false
```
## Toggle song playback (PREMIUM ONLY)
```lua
local spotify = require(game:GetService("ReplicatedStorage").Folder.Spotify)
spotify:TogglePlayback(true) -- true/false, leave blank to play/pause
```
## Play song
```lua
local spotify = require(game:GetService("ReplicatedStorage").Folder.Spotify)
spotify:Play("0aB0v4027ukVziUGwVGYpG") -- tv off
```
## Skip song
```lua
local spotify = require(game:GetService("ReplicatedStorage").Folder.Spotify)
spotify:SkipCurrent(2) -- Leave blank to skip forward once, positive/negative to go forward or back
```
# Credits
Spotify.lua: @qwertyui-is-back