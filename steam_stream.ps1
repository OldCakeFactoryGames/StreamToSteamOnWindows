<#
.SYNOPSIS
Transcodes and streams a video file to Steam Broadcast.

.DESCRIPTION
This script takes a source video file and an upload token as input, then uses FFmpeg to transcode
and stream the video to the Steam Broadcast service. It configures FFmpeg with recommended settings
for audio and video encoding, resolution, and frame rate.

.PARAMETER SourceFile
The path to the video file to be streamed.

.PARAMETER UploadToken
Your Steam Broadcast upload token.

.EXAMPLE
.\steam-stream.ps1 -SourceFile "path/to/your/video.mp4" -UploadToken "your_upload_token"

.NOTES
Requires FFmpeg to be installed and in your system's PATH.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$SourceFile,

    [Parameter(Mandatory=$true)]
    [string]$UploadToken
)

# Steam ingest server address
$IngestServer = "rtmp://ingest-rtmp.broadcast.steamcontent.com/app"

# Video and audio bitrates
$VideoBitRate = "2500k"
$AudioBitRate = "160k"

# Keyframe interval in seconds
$KeyFrameIntervalSeconds = 2

# Video settings
$FrameRate = 30
$Resolution = "1280x720"
$FFmpegPreset = "medium"

# Calculate the keyframe interval in frames
$KeyFrameIntervalFrames = $FrameRate * $KeyFrameIntervalSeconds

# Construct the FFmpeg command
$FFmpegCommand = "ffmpeg"
$Arguments = @(
    "-re"
    "-stream_loop"
    "-1"
    "-i"
    "$SourceFile"
    "-f"
    "flv"
    "-vcodec"
    "libx264"
    "-acodec"
    "aac"
    "-pix_fmt"
    "yuv420p"
    "-b:v"
    "$VideoBitRate"
    "-minrate"
    "$VideoBitRate"
    "-maxrate"
    "$VideoBitRate"
    "-bufsize"
    "$VideoBitRate"
    "-b:a"
    "$AudioBitRate"
    "-s"
    "$Resolution"
    "-filter:v"
    "fps=$FrameRate"
    "-g"
    "$KeyFrameIntervalFrames"
    "-flvflags"
    "no_duration_filesize"
    "-preset"
    "$FFmpegPreset"
    "$IngestServer/$UploadToken"
)

# Execute the FFmpeg command
Write-Host "Starting streaming with the following command:"
Write-Host "$FFmpegCommand $($Arguments -join ' ')"
try {
    Start-Process -FilePath $FFmpegCommand -ArgumentList $Arguments -NoNewWindow -Wait
    Write-Host "Streaming finished."
}
catch {
    Write-Error "An error occurred while running FFmpeg: $($_.Exception.Message)"
}