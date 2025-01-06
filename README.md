# SpotifyAPI
### An API used for roblox to implement the Spotify API.

# Features

- Update the Spotify token
- Get currently playing song data
- Pause & Play music

# Instructions
## Installation
In order for this to work, you're going to need to enable 'Allow Http Requests' in your games ssttingd.

First, make a folder in your Roblox project. You can name the folder whatever.
Then, go inside [Spotify.lua](https://github.com/qwertyui-is-back/SpotifyAPI/blob/main/Spotify.lua), and copy the code.
You will then want to make a file in the folder called 'Spotify', and paste the code.

Now, you will want to make a folder on your desktop, and ame it whaterver.
Then, download [API.py](https://github.com/qwertyui-is-back/SpotifyAPI/blob/main/API.py), and move the file to the folder you made.

Make sure you have [Python](https://python.org) installed.
Open `cmd` in the folder, and run:
```py
pip install flask
```
Once finished, run:
```py
python API.py
```
This API will allow you to update your access token easily.
## Setup

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
