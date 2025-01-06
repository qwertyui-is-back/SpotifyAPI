# SpotifyAPI
### An API used for roblox to implement the Spotify API.

# Features

- Update the Spotify token
- Set the Spotify token type
- Get currently playing song data
- Pause & Play music

# Instructions

In order for this to work, you're going to need to enable 'Http requests' in your games ssttingd.

First, you're going to need a Base64 library. I recommend [this library by Gooncreeper](https://devforum.roblox.com/t/insanely-fast-base64-module/2039488).
Make sure that your library has these main functions:
- b64.encode
- b64.decode

If your library doesn't have these functions, it will not work.

Next, make a folder in your Roblox project. You will want to place that Base64 script in that folder. You can name the folder whatever.
Then, go inside [Spotify.lua](https://github.com/qwertyui-is-back/SpotifyAPI/blob/main/Spotify.lua), and copy the code.

You will then want to make a file in the folder called 'Spotify', and paste the code.

You are now finished, and can use the Spotify API

# Examples
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
## Toggle song playback
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