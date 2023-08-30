#!/bin/bash

for d in */ ; do
  DIR="$d"
  LISTVIDEO=("$DIR"/*.avi "$DIR"/*.mp4)

  for VAR in "${LISTVIDEO[@]}"; do
    NEWVAR=$( echo "$VAR" | rev | cut -c 5- | rev)
    ffmpeg -hwaccel auto -i "$VAR" -c:v libsvtav1 -pass 1 -an -f null /dev/null && \
      ffmpeg -hwaccel auto -i "$VAR" -c:v libsvtav1 -pass 2 -c:a libopus -ac 2 -b:a 160k -map 0 -c:s copy "$NEWVAR.mkv"
  done
done
rm ffmpeg2pass-0.log
