user_id=2f3debea802442e986d45ef0cc1f90d5 # generated on https://developer.spotify.com/dashboard/applications
secret_id=51249c59bb514f60a8554f0571b92330

myToken=$(curl -s -X 'POST' -u $user_id:$secret_id -d grant_type=client_credentials https://accounts.spotify.com/api/token | jq '.access_token' | cut -d\" -f2)
RESULT=$?

if [ "$PLAYER_EVENT" = "start" ];
then
    if [ $RESULT -eq 0 ]; then
        curl -s -X 'GET' https://api.spotify.com/v1/tracks/$TRACK_ID -H 'Accept: application/json' -H 'Content-Type: application/json' -H "Authorization:\"Bearer $myToken\"" | jq '.name, .artists[].name, .album.name, .album.release_date, .track_number, .album.total_tracks' | xargs printf "\"Playing '%s' from '%s' (album: '%s' in %s (%s/%s))\"" | xargs notify-send --urgency=low --expire-time=3000 --icon=/usr/share/icons/gnome/32x32/actions/player_play.png --app-name=spotifyd spotifyd
    else
        echo "Cannot get token."
    fi
elif [ "$PLAYER_EVENT" = "change" ];
then
    if [ $RESULT -eq 0 ]; then
        curl -s -X 'GET' https://api.spotify.com/v1/tracks/$TRACK_ID -H 'Accept: application/json' -H 'Content-Type: application/json' -H "Authorization:\"Bearer $myToken\"" | jq '.name, .artists[].name, .album.name, .album.release_date, .track_number, .album.total_tracks' | xargs printf "\"Music changed to '%s' from '%s' (album: '%s' in %s (%s/%s))\"" | xargs notify-send --urgency=low --expire-time=3000 --icon=/usr/share/icons/gnome/32x32/actions/player_fwd.png --app-name=spotifyd spotifyd
    else
        echo "Cannot get token."
    fi
elif [ "$PLAYER_EVENT" = "stop" ];
then
    if [ $RESULT -eq 0 ]; then
        curl -s -X 'GET' https://api.spotify.com/v1/tracks/$TRACK_ID -H 'Accept: application/json' -H 'Content-Type: application/json' -H "Authorization:\"Bearer $myToken\"" | jq '.name, .artists[].name, .album.name, .album.release_date, .track_number, .album.total_tracks' | xargs printf "Stoping music (Last song: '%s' from '%s' (album: '%s' in %s (%s/%s)))\"" | xargs notify-send --urgency=low --expire-time=3000 --icon=/usr/share/icons/gnome/32x32/actions/player_stop.png --app-name=spotifyd spotifyd
    else
        echo "Cannot get token."
    fi
else
    echo "Unkown event."
fi
