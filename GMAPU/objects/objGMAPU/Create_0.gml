/// @description Variables
audio_stop_all();

GMAPU_init_instruments();

__playing = false;
__paused = false;

__songStep = 0;
__songClock = noone;
__songInit = false;
__channelInfo = array_create(GMAPU_CHANNEL_COUNT, array_create(__GMAPU_SONG_DATA.LENGTH, -1));
__songSpeed = 6;
__songVolume = 1.0;


window_set_size((256 * 3), (240 * 3));