#!/usr/bin/env bash

state=$(swaync-client -D)

if [[ "$state" == "true" ]];then
    exit 0
fi

mpv ~/.config/swaync/sound/critical.oga
