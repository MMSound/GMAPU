//GMAPU - sequenced audio in pure GML by MiniMacro Sound

//system macros
#macro GMAPU_CHANNEL_PRIORITY 0 //the starting priority channel of GMAPU
#macro GMAPU_CHANNEL_COUNT 4 //the amount of channels dedicated to GMAPU
#macro GMAPU_TIME_DEPTH 72 //the amount of repetitions before GMAPU resets the time source - must be larger than 5 (NOTE: maybe make this depend on the length of the song?)

//note macros
#macro nC_0 0.12
#macro nCs0 0.13
#macro nD_0 0.14
#macro nDs0 0.15
#macro nE_0 0.16
#macro nF_0 0.17
#macro nFs0 0.18
#macro nG_0 0.19
#macro nGs0 0.20
#macro nA_0 0.21
#macro nAs0 0.22
#macro nB_0 0.24
#macro nC_1 0.25
#macro nCs1 0.27
#macro nD_1 0.28
#macro nDs1 0.30
#macro nE_1 0.32
#macro nF_1 0.33
#macro nFs1 0.35
#macro nG_1 0.37
#macro nGs1 0.40
#macro nA_1 0.42
#macro nAs1 0.45
#macro nB_1 0.47
#macro nC_2 0.50
#macro nCs2 0.53
#macro nD_2 0.56
#macro nDs2 0.60
#macro nE_2 0.63
#macro nF_2 0.67
#macro nFs2 0.71
#macro nG_2 0.75
#macro nGs2 0.80
#macro nA_2 0.85
#macro nAs2 0.90
#macro nB_2 0.95
#macro nC_3 1.00
#macro nCs3 1.06
#macro nD_3 1.12
#macro nDs3 1.19
#macro nE_3 1.27
#macro nF_3 1.34
#macro nFs3 1.42
#macro nG_3 1.50
#macro nGs3 1.59
#macro nA_3 1.69
#macro nAs3 1.79
#macro nB_3 1.90
#macro nC_4 2.00
#macro nCs4 2.12
#macro nD_4 2.26
#macro nDs4 2.38
#macro nE_4 2.52
#macro nF_4 2.68
#macro nFs4 2.84
#macro nG_4 3.00
#macro nGs4 3.18
#macro nA_4 3.38
#macro nAs4 3.57
#macro nB_4 3.79
#macro nC_5 4.00
#macro nCs5 4.24
#macro nD_5 4.51
#macro nDs5 4.76
#macro nE_5 5.04
#macro nF_5 5.36
#macro nFs5 5.64
#macro nG_5 6.04
#macro nGs5 6.40
#macro nA_5 6.70
#macro nAs5 7.14
#macro nB_5 7.52
#macro nC_6 8.09
#macro nCs6 8.57
#macro nD_6 8.93
#macro nDs6 9.53
#macro nE_6 10.21
#macro nF_6 10.72
#macro nFs6 11.28
#macro nG_6 11.91
#macro nGs6 12.61
#macro nA_6 13.39
#macro nAs6 14.29
#macro nB_6 15.31
#macro nC_7 15.88
#macro nOFF 72
#macro n___ 64

//enums
enum __GMAPU_SONG_DATA
{
	NOTE,
	INSTRUMENT,
	SOUNDID,
	GAIN,
}

/// @description call in the beginning of your game if you don't just want to place the object in the room
function GMAPU_init()
{
	if (!instance_exists(objGMAPU))
	{
		instance_create_depth(0, 0, 0, objGMAPU);
	}
}

/// @description play a new song
function GMAPU_playback_start(_song = noone)
{
	with (objGMAPU)
	{
		for (var i = 0; i < array_length(__channelInfo); i++)
		{
			audio_stop_sound(__channelInfo[i][__GMAPU_SONG_DATA.SOUNDID]);
		}			
		if (time_source_exists(__songClock))
		{
			time_source_destroy(__songClock, true);
		}
		__GMAPU_init_song_clock();
		
		__playing = true;
		__paused = false;
		
		__songStep = 0;
		__songSpeed = 6;
		__songVolume = 1.0;
	}
}

/// @description pause and resume the current song
/// WRITE DOCS LATER
function GMAPU_playback_pause(_pause = -1)
{
	with (objGMAPU)
	{
		if ((!__paused && _pause == -1) || (_pause == true))
		{
			if (time_source_exists(__songClock))
			{
				time_source_pause(__songClock); //the manual said the global time source can't be paused but that seems to be untrue
			}
			for (var i = 0; i < array_length(__channelInfo); i++)
			{
				audio_pause_sound(__channelInfo[i][__GMAPU_SONG_DATA.SOUNDID]);
			}
			__paused = true;
		}
		else if ((__paused && _pause == -1) || (_pause == false))
		{
			if (time_source_exists(__songClock))
			{
				time_source_resume(__songClock); //the manual said the global time source can't be paused but that seems to be untrue
			}
			for (var i = 0; i < array_length(__channelInfo); i++)
			{
				audio_resume_sound(__channelInfo[i][__GMAPU_SONG_DATA.SOUNDID]);
			}
			__paused = false;
		}
	}
}

/// @description stop the current song
function GMAPU_playback_stop()
{
	with (objGMAPU)
	{
		for (var i = 0; i < array_length(__channelInfo); i++)
		{
			audio_stop_sound(__channelInfo[i][__GMAPU_SONG_DATA.SOUNDID]);
		}			
		if (time_source_exists(__songClock))
		{
			time_source_destroy(__songClock, true);
		}
		__playing = false;
	}
}

/// @description clear GMAPU
function GMAPU_destroy()
{
	with (objGMAPU)
	{
		if (time_source_exists(__songClock))
		{
			time_source_destroy(__songClock, true);
		}
		instance_destroy(id);
	}
}

// INTERNAL FUNCTIONS (don't call outside of objGMAPU or scripts for using it)

/// @description init the song clock
function __GMAPU_init_song_clock(_start = true)
{
	__songClock = time_source_create(time_source_game, 1, time_source_units_frames, __GMAPU_update, [], array_length(__songData), time_source_expire_nearest);
	if (_start)
	{
		time_source_start(__songClock);
	}
	__songInit = false; //we're not resetting the song step in the event that we need to reinitialize the clock mid-song, we don't want to restart it
}

/// @description plays a note
function __GMAPU_play_note(_note, _inst, _channel = 0, _gain = 1.0)
{
	if (_note != n___)
	{
		if (audio_is_playing(__channelInfo[_channel][__GMAPU_SONG_DATA.SOUNDID]))
		{
			audio_stop_sound(__channelInfo[_channel][__GMAPU_SONG_DATA.SOUNDID]);
		}
		if (_note != nOFF)
		{
			var _played = audio_play_sound(_inst.__soundID, (GMAPU_CHANNEL_PRIORITY + _channel), _inst.__loops);
			audio_sound_pitch(_played, _note);
			audio_sound_gain(_played, (_gain * __songVolume), 0);
			if (_inst.__loops)
			{
				audio_sound_loop_start(_played, _inst.__loopStart);
				audio_sound_loop_end(_played, _inst.__loopEnd);
			}
			
			return [_note, _inst, _played, _gain];
		}
		else
		{
			return [nOFF, -1, -1, 0];
		}
	}
	return __channelInfo[_channel];
}

/// @description advance 1 step in the currently playing song
function __GMAPU_update()
{
	with (objGMAPU)
	{
		if (!__songInit)
		{
			time_source_reconfigure(__songClock, (__songSpeed / 60), time_source_units_seconds, __GMAPU_update, [], (array_length(__songData) - __songStep), time_source_expire_after);
			time_source_start(__songClock);
			__songInit = true;
		}
		
		var _length = clamp(GMAPU_CHANNEL_COUNT, 0, (array_length(__songData[0]) - 1)); //if the song has fewer channels than the total, we want to avoid errors
		for (var i = 0; i < _length; i++)
		{
			var _current = __channelInfo[i];
			var _note = __songData[__songStep][i + 1][__GMAPU_SONG_DATA.NOTE];
			var _inst = __songData[__songStep][i + 1][__GMAPU_SONG_DATA.INSTRUMENT];
			var _gain = __songData[__songStep][i + 1][__GMAPU_SONG_DATA.GAIN];
		
			if (_inst == -1) //-1 can be used in these parameters to repeat what was already there
			{
				_inst = _current[__GMAPU_SONG_DATA.INSTRUMENT];
			}
			
			if (_gain == -1)
			{
				_gain = _current[__GMAPU_SONG_DATA.GAIN];
			}
			else //adjust gain on currently playing notes
			{
				if (_note == n___)
				{
					if (audio_is_playing(_current[__GMAPU_SONG_DATA.SOUNDID]))
					{
						audio_sound_gain(_current[__GMAPU_SONG_DATA.SOUNDID], _gain, 0);
					}
				}
				__channelInfo[i][__GMAPU_SONG_DATA.GAIN] = _gain;
			}
		
			__channelInfo[i] = __GMAPU_play_note(_note, _inst, i, _gain); //we're using i + 1 here because the first index of the song data array is for tempo data
		}

		if (__songData[__songStep][0] != -1) //changing song speed mid-song
		{
			__songSpeed = __songData[__songStep][0];
			time_source_reconfigure(__songClock, (__songSpeed / 60), time_source_units_seconds, __GMAPU_update, [], (array_length(__songData) - __songStep), time_source_expire_after);
			time_source_start(__songClock);
		}
		
		if (time_source_get_reps_remaining(__songClock) == 0) //looping
		{
			time_source_reset(__songClock);
			time_source_start(__songClock);
		}
		
		__songStep = ((__songStep + 1) % array_length(__songData));
	}
}

// INSTRUMENT FUNCTIONS

function __Instrument(_sound, _loopStart = -1, _loopEnd = -1) constructor
{
	__soundID = _sound;
	__loops = ((_loopStart != -1) && (_loopEnd != -1));
	__loopStart = _loopStart;
	__loopEnd = _loopEnd;
	
	//static functions down here
}

// FUN STUFF

function __GMAPU_get_note_name(_note)
{
	switch (_note)
	{
		default: return "   "; break;
		case 0.12: return "C-0"; break;
		case 0.13: return "C#0"; break;
		case 0.14: return "D-0"; break;
		case 0.15: return "D#0"; break;
		case 0.16: return "E-0"; break;
		case 0.17: return "F-0"; break;
		case 0.18: return "F#0"; break;
		case 0.19: return "G-0"; break;
		case 0.20: return "G#0"; break;
		case 0.21: return "A-0"; break;
		case 0.22: return "A#0"; break;
		case 0.24: return "B-0"; break;
		case 0.25: return "C-1"; break;
		case 0.27: return "C#1"; break;
		case 0.28: return "D-1"; break;
		case 0.30: return "D#1"; break;
		case 0.32: return "E-1"; break;
		case 0.33: return "F-1"; break;
		case 0.35: return "F#1"; break;
		case 0.37: return "G-1"; break;
		case 0.40: return "G#1"; break;
		case 0.42: return "A-1"; break;
		case 0.45: return "A#1"; break;
		case 0.47: return "B-1"; break;
		case 0.50: return "C-2"; break;
		case 0.53: return "C#2"; break;
		case 0.56: return "D-2"; break;
		case 0.60: return "D#2"; break;
		case 0.63: return "E-2"; break;
		case 0.67: return "F-2"; break;
		case 0.71: return "F#2"; break;
		case 0.75: return "G-2"; break;
		case 0.80: return "G#2"; break;
		case 0.85: return "A-2"; break;
		case 0.90: return "A#2"; break;
		case 0.95: return "B-2"; break;
		case 1.00: return "C-3"; break;
		case 1.06: return "C#3"; break;
		case 1.12: return "D-3"; break;
		case 1.19: return "D#3"; break;
		case 1.27: return "E-3"; break;
		case 1.34: return "F-3"; break;
		case 1.42: return "F#3"; break;
		case 1.50: return "G-3"; break;
		case 1.59: return "G#3"; break;
		case 1.69: return "A-3"; break;
		case 1.79: return "A#3"; break;
		case 1.90: return "B-3"; break;
		case 2.00: return "C-4"; break;
		case 2.12: return "C#4"; break;
		case 2.26: return "D-4"; break;
		case 2.38: return "D#4"; break;
		case 2.52: return "E-4"; break;
		case 2.68: return "F-4"; break;
		case 2.84: return "F#4"; break;
		case 3.00: return "G-4"; break;
		case 3.18: return "G#4"; break;
		case 3.38: return "A-4"; break;
		case 3.57: return "A#4"; break;
		case 3.79: return "B-4"; break;
		case 4.00: return "C-5"; break;
		case 4.24: return "C#5"; break;
		case 4.51: return "D-5"; break;
		case 4.76: return "D#5"; break;
		case 5.04: return "E-5"; break;
		case 5.36: return "F-5"; break;
		case 5.64: return "F#5"; break;
		case 6.04: return "G-5"; break;
		case 6.40: return "G#5"; break;
		case 6.70: return "A-5"; break;
		case 7.14: return "A#5"; break;
		case 7.52: return "B-5"; break;
		case 8.09: return "C-6"; break;
		case 8.57: return "C#6"; break;
		case 8.93: return "D-6"; break;
		case 9.53: return "D#6"; break;
		case 10.21: return "E-6"; break;
		case 10.72: return "F-6"; break;
		case 11.28: return "F#6"; break;
		case 11.91: return "G-6"; break;
		case 12.61: return "G#6"; break;
		case 13.39: return "A-6"; break;
		case 14.29: return "A#6"; break;
		case 15.31: return "B-6"; break;
		case 15.88: return "C-7"; break;
		case 72: return "---"; break;
		case 64: return "   "; break;
	}
}