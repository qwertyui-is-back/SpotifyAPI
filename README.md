# SpotifyAPI
### An API used for roblox to implement the Spotify API.

# Features

- Update the Spotify token
- Get currently playing song data
- Pause & Play music

# Instructions
## Installation
In order for this to work, you're going to need to enable 'Allow Http Requests' in your game settings.

First, make a folder in your Roblox project, in either ReplicatedStorage or ServerStorage. You can name the folder whatever.
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
### Spotify app
You will need to create an application for your users to sign into, giving you a Client ID, and Client Secret.

First, go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard), and login if you aren't.
You will then need to press 'Create App', and fill out the information.
**IMPORTANT: Set Redirect URIs to ``` http://localhost:80/callback```**
**, and press ADD.**
Once finished, scroll down and toggle **Web API** and **Web Playback SDK**.

Press save, and click **SETTINGS**. Click **'View client secret'**, and here is your Client ID and Client Secret. Make sure to copy these!
### Code
Now that you have your application setup, you can now begin coding.

Before doing anything, make sure you define this:
```lua
local spotify = require(game.ReplicatedStorage.Folder.Spotify)

spotify.RedirectUri = "http://localhost:80/callback" -- DO NOT CHANGE
spotify.ClientId = "CLIENT ID" -- PASTE CLIENT ID FROM APPLICATION
spotify.ClientSecret = "CLIENT SECRET" -- PASTE CLIENT SECRE5 FROM APPLICATION
```
Now, if you want to get your user's access token & refresh token, add this:
```lua
local url = spotify:GenerateURL({"user-read-private", "user-read-email", "user-read-playback-state", "user-modify-playback-state"})
-- Your user needs to visit that link, login, and authorize the application.
-- They will then be sent to the API you set up, and they need to copy the code on the page.
-- After, do this with the code
spotify:HandleCode(COPIED_CODE) -- Paste the code
-- This automatically sets the refresh & access token, but you can also set it as a variable.
```
Congratulations! You have now setup the Spotify API!
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
Spotify.lua: @qwertyui-is-back, @MaxlaserTech