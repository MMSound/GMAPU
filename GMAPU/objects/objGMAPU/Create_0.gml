/// @description Variables
audio_stop_all();

__playing = false;
__paused = false;

__songStep = 0;
__songClock = noone;
__songInit = false;
__channelInfo = array_create(GMAPU_CHANNEL_COUNT, [-1, -1, -1, -1]);
__songSpeed = 6;
__songVolume = 1.0;

__instrumentData[0] = new __Instrument(smpPiano, -1, -1);
__instrumentData[1] = new __Instrument(smpPulse125, 0, audio_sound_length(smpPulse125));
#macro __PIANO __instrumentData[0]
#macro __PULSE __instrumentData[1]


window_set_size((256 * 3), (240 * 3));