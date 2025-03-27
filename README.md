## Stream to Steam from Windows Powershell

This repository is an adaption of this https://github.com/cowleyforniastudios/steam-stream but for windows.
All the thanks to them for their work!

1. Open Powershell
2. Install ffmpeg

`winget install ffmpeg` or `choco install ffmpeg`. Winget should already be installed on Windows 11 (as its from Microsoft), else you can install it or choco, follow the respective steps on their websites.

3. Clone this repository
4. Put your video file in the same folder
5. Setup your Stream and get your Upload Token here: https://steamcommunity.com/broadcast/upload/
6. Then call `.\steam_stream.ps1 .\<stream_file>.mp4 "<upload_token>"` from the powershell window
7. Voila, check your steam page, the stream should appear, but it may have a bit of a delay.

## Quality Settings

You can play around with the quality settings inside the file, there are variables for various settings like quality presets and stream resolution.

