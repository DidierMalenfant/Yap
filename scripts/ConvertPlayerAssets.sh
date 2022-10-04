#!/bin/sh
#
# SPDX-FileCopyrightText: 2022-present Didier Malenfant <coding@malenfant.net>
#
# SPDX-License-Identifier: MIT

dither() {
    DIDDER_ARGS='didder --palette "black white" -i "'
    DIDDER_ARGS+="$1"
    DIDDER_ARGS+='.png" -o "'
    DIDDER_ARGS+="$1"
    DIDDER_ARGS+='.png" --strength -0.75 --brightness 0.32 --contrast 0.44 bayer 64x64'
    eval $DIDDER_ARGS
}

# -- Convert Idle anim into separate frames
magick convert -crop 128x128 "Hiro's Cliúch‚ Quest!! Hero Spritesheets/1 Hiro's Core Animations/IDLE,WALK,TURN/1 IDLE [LOOP].png" ./idle.png
dither 'idle-0'
dither 'idle-1'
dither 'idle-2'
dither 'idle-3'
dither 'idle-4'
dither 'idle-5'
dither 'idle-6'
rm idle-7.png

magick convert -crop 128x128 "Hiro's Cliúch‚ Quest!! Hero Spritesheets/1 Hiro's Core Animations/IDLE,WALK,TURN/2 RUN START TRANSITION.png" ./runstart.png
dither 'runstart-0'
dither 'runstart-1'

magick convert -crop 128x128 "Hiro's Cliúch‚ Quest!! Hero Spritesheets/1 Hiro's Core Animations/IDLE,WALK,TURN/3 RUN [LOOP].png" ./run.png
dither 'run-0'
dither 'run-1'
dither 'run-2'
dither 'run-3'
dither 'run-4'
dither 'run-5'

magick convert -crop 128x128 "Hiro's Cliúch‚ Quest!! Hero Spritesheets/1 Hiro's Core Animations/IDLE,WALK,TURN/4 RUN STOP TRANSITION.png" ./runstop.png
dither 'runstop-0'
dither 'runstop-1'

magick convert -crop 128x128 "Hiro's Cliúch‚ Quest!! Hero Spritesheets/1 Hiro's Core Animations/IDLE,WALK,TURN/TURN.png" ./turn.png
dither 'turn-0'
dither 'turn-1'
dither 'turn-2'
dither 'turn-3'
dither 'turn-4'
dither 'turn-5'

magick montage -mode concatenate -background none -tile 8x idle-*.png runstart-*.png run-*.png runstop-*.png turn-*.png player-table-128-128.png

rm idle-*
rm runstart-*
rm run-*
rm runstop-*
rm turn-*
