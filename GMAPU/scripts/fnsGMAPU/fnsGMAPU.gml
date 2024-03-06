//GMAPU - sequenced audio in pure GML by MiniMacro Sound

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
	FADE,
	PITCH,
	LENGTH
}

enum __GMAPU_TRACK_DATA
{
	SPEED,
	LOOP,
	LENGTH
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
		if (_song != noone)
		{
			__songData = _song();
		}
		else
		{
			show_message("GMAPU - No song specified!");
			exit;
		}
		
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

/// @description call when GMAPU needs to be cleaned (at the end of your game, or right before you reset - this will prevent the time source that drives the system from glitching)
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

// INTERNAL FUNCTIONS (don't call outside of objGMAPU or functions for using it)

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
function __GMAPU_play_note(_note, _inst, _channel = 0, _gain = 1.0, _fade = noone, _pitch = 0)
{
	with (objGMAPU)
	{
		if (_note == n___)
		{
			return __channelInfo[_channel];
		}
	
		if (audio_is_playing(__channelInfo[_channel][__GMAPU_SONG_DATA.SOUNDID]))
		{
			audio_stop_sound(__channelInfo[_channel][__GMAPU_SONG_DATA.SOUNDID]);
		}
	
		if (_note == nOFF)
		{
			return [nOFF, -1, -1, 0, -1, 0];
		}
	
		var _played = audio_play_sound(_inst.__soundID, (GMAPU_CHANNEL_PRIORITY + _channel), _inst.__loops);
		audio_sound_pitch(_played, (_note + _pitch));
		audio_sound_gain(_played, (_gain * __songVolume), 0);
	
		//EFFECTS PROCESSING PART 2 - taking the data we got from __GMAPU_update() and applying it to new notes
		if (_fade != noone)
		{
			audio_sound_gain(_played, (_fade[0] * __songVolume), _fade[1]);
		}
	
		if (_inst.__loops)
		{
			audio_sound_loop_start(_played, _inst.__loopStart);
			audio_sound_loop_end(_played, _inst.__loopEnd);
		}
	
		return [_note, _inst, _played, _gain, _fade, _pitch];
	}
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
			var _note = __songData[__songStep][i + 1][__GMAPU_SONG_DATA.NOTE]; //we're using i + 1 here because the first index of the song data array is for tempo data
			var _inst = __songData[__songStep][i + 1][__GMAPU_SONG_DATA.INSTRUMENT];
			var _gain = __songData[__songStep][i + 1][__GMAPU_SONG_DATA.GAIN];
			var _fade = __songData[__songStep][i + 1][__GMAPU_SONG_DATA.FADE];
			var _pitch = __songData[__songStep][i + 1][__GMAPU_SONG_DATA.PITCH];
			
			//EFFECTS PROCESSING PART 1 - turning them into usable data, and processing them on rows where there's not a new note
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
			
			if (_fade == -1)
			{
				_fade = noone;
			}
			else
			{
				if (_note == n___)
				{
					if (audio_is_playing(_current[__GMAPU_SONG_DATA.SOUNDID]))
					{
						audio_sound_gain(_current[__GMAPU_SONG_DATA.SOUNDID], _fade[0], _fade[1]);
					}
				}
				__channelInfo[i][__GMAPU_SONG_DATA.FADE] = _fade;				
			}
			
			__channelInfo[i] = __GMAPU_play_note(_note, _inst, i, _gain, _fade, _pitch);
		}

		if (__songData[__songStep][0][__GMAPU_TRACK_DATA.SPEED] != -1) //changing song speed mid-song
		{
			__songSpeed = __songData[__songStep][0][__GMAPU_TRACK_DATA.SPEED];
			time_source_reconfigure(__songClock, (__songSpeed / 60), time_source_units_seconds, __GMAPU_update, [], (array_length(__songData) - __songStep), time_source_expire_after);
			time_source_start(__songClock);
		}
		
		if (time_source_get_reps_remaining(__songClock) == 0) //looping
		{
			time_source_reset(__songClock);
			time_source_start(__songClock);
		}
		
		var _loop = __songData[__songStep][0][__GMAPU_TRACK_DATA.LOOP];
		__songStep = (_loop == -1 ? ((__songStep + 1) % array_length(__songData)) : _loop);
	}
}

// INSTRUMENT FUNCTIONS

function __Instrument(_sound, _loopStart = -1, _loopEnd = -1) constructor
{
	__soundID = _sound;
	__loops = ((_loopStart != -1) && (_loopEnd != -1));
	__loopStart = _loopStart;
	__loopEnd = _loopEnd;
}

// FUN STUFF

/// @description not super well coded, and frankly also not necessary for proper function, but it can be used for neat visualizations
function __GMAPU_get_note_name(_note)
{
	if (_note <= 0.12) return "C-0";
	else if (_note <= 0.13) return "C#0";
	else if (_note <= 0.14) return "D-0";
	else if (_note <= 0.15) return "D#0";
	else if (_note <= 0.16) return "E-0";
	else if (_note <= 0.17) return "F-0";
	else if (_note <= 0.18) return "F#0";
	else if (_note <= 0.19) return "G-0";
	else if (_note <= 0.20) return "G#0";
	else if (_note <= 0.21) return "A-0";
	else if (_note <= 0.22) return "A#0";
	else if (_note <= 0.24) return "B-0";
	else if (_note <= 0.25) return "C-1";
	else if (_note <= 0.27) return "C#1";
	else if (_note <= 0.28) return "D-1";
	else if (_note <= 0.30) return "D#1";
	else if (_note <= 0.32) return "E-1";
	else if (_note <= 0.33) return "F-1";
	else if (_note <= 0.35) return "F#1";
	else if (_note <= 0.37) return "G-1";
	else if (_note <= 0.40) return "G#1";
	else if (_note <= 0.42) return "A-1";
	else if (_note <= 0.45) return "A#1";
	else if (_note <= 0.47) return "B-1";
	else if (_note <= 0.50) return "C-2";
	else if (_note <= 0.53) return "C#2";
	else if (_note <= 0.56) return "D-2";
	else if (_note <= 0.60) return "D#2";
	else if (_note <= 0.63) return "E-2";
	else if (_note <= 0.67) return "F-2";
	else if (_note <= 0.71) return "F#2";
	else if (_note <= 0.75) return "G-2";
	else if (_note <= 0.80) return "G#2";
	else if (_note <= 0.85) return "A-2";
	else if (_note <= 0.90) return "A#2";
	else if (_note <= 0.95) return "B-2";
	else if (_note <= 1.00) return "C-3";
	else if (_note <= 1.06) return "C#3";
	else if (_note <= 1.12) return "D-3";
	else if (_note <= 1.19) return "D#3";
	else if (_note <= 1.27) return "E-3";
	else if (_note <= 1.34) return "F-3";
	else if (_note <= 1.42) return "F#3";
	else if (_note <= 1.50) return "G-3";
	else if (_note <= 1.59) return "G#3";
	else if (_note <= 1.69) return "A-3";
	else if (_note <= 1.79) return "A#3";
	else if (_note <= 1.90) return "B-3";
	else if (_note <= 2.00) return "C-4";
	else if (_note <= 2.12) return "C#4";
	else if (_note <= 2.26) return "D-4";
	else if (_note <= 2.38) return "D#4";
	else if (_note <= 2.52) return "E-4";
	else if (_note <= 2.68) return "F-4";
	else if (_note <= 2.84) return "F#4";
	else if (_note <= 3.00) return "G-4";
	else if (_note <= 3.18) return "G#4";
	else if (_note <= 3.38) return "A-4";
	else if (_note <= 3.57) return "A#4";
	else if (_note <= 3.79) return "B-4";
	else if (_note <= 4.00) return "C-5";
	else if (_note <= 4.24) return "C#5";
	else if (_note <= 4.51) return "D-5";
	else if (_note <= 4.76) return "D#5";
	else if (_note <= 5.04) return "E-5";
	else if (_note <= 5.36) return "F-5";
	else if (_note <= 5.64) return "F#5";
	else if (_note <= 6.04) return "G-5";
	else if (_note <= 6.40) return "G#5";
	else if (_note <= 6.70) return "A-5";
	else if (_note <= 7.14) return "A#5";
	else if (_note <= 7.52) return "B-5";
	else if (_note <= 8.09) return "C-6";
	else if (_note <= 8.57) return "C#6";
	else if (_note <= 8.93) return "D-6";
	else if (_note <= 9.53) return "D#6";
	else if (_note <= 10.21) return "E-6";
	else if (_note <= 10.72) return "F-6";
	else if (_note <= 11.28) return "F#6";
	else if (_note <= 11.91) return "G-6";
	else if (_note <= 12.61) return "G#6";
	else if (_note <= 13.39) return "A-6";
	else if (_note <= 14.29) return "A#6";
	else if (_note <= 15.31) return "B-6";
	else if (_note <= 15.88) return "C-7";
	else if (_note == 72) return "---";
	else if (_note == 64) return "   ";
	else return "   ";
}