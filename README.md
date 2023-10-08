# eet-start-linux
Script that starts Infinity Engine games on Linux with minor enhancements

This project consists of a single shell script `eet-start.sh`. The default
configuration assumes that there is a `BaldursGateII` binary of
*Baldur's Gate - Enhanced Edition Trilogy* game installed in `eet/game` path
relative to the script. You can change said configuration in the first section
of the script. The main objective is to enable extra features.

## libmtrandom support

If you unpack a release of [libmtrandom](https://github.com/dtiefling/libmtrandom)
in the `resources` directory, this script will make sure that the library
is preloaded. It is one of the ways known to make the rolls in the game behave
closer to the actual random process - as it uses `rand()`, which is known to lead
to more repetitons than expected from independent rolls.

## Fancy icon

Unless you are playing fullscreen exclusively, you might find it disappointing
that the Linux build of the game comes with no icon. You can fix it by
cloning and building [xseticon](https://github.com/xeyownt/xseticon)
in the resources directory. You can also change `resources/icon.png`
file to anything you like.
