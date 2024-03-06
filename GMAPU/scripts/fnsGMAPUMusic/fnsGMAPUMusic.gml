//music data for GMAPU - this is where you will want to do the bulk of your editing

//system constants
#macro GMAPU_CHANNEL_PRIORITY 0 //the starting priority channel of GMAPU
#macro GMAPU_CHANNEL_COUNT 4 //the amount of channels dedicated to GMAPU

/// @description initialize instruments
function GMAPU_init_instruments()
{
	__instrumentData[0] = new __Instrument(smpPiano, -1, -1);
	__instrumentData[1] = new __Instrument(smpPulse125, 0, audio_sound_length(smpPulse125));
}

#macro __PIANO __instrumentData[0]
#macro __PULSE __instrumentData[1]

//these macros are so song data looks a little more readable at a glance and are purely just for convenience
#macro _ 0
#macro __ -1

//ultimately these are all functions so they can be easily passed as arguments
//given that it's just a bunch of arrays, i don't think it's necessary to store them before they need to be loaded
//so they can just be functions

// MUSIC FORMAT
//this is designed to be legible to the programmer and the skilled musician alike, and especially for those who are already familiar with trackers
//it is currently extremely tedious to enter data manually in this format, but it can be done
//at some point i plan to outline a text file spec and program a conversion tool to make it even easier to insert music, but that isn't a top priority right now
//i do welcome community contributions though, just saying... :)

//here's how this is arranged:
//the first index of each array is the "track data" - this information controls the flow of the track
	//[speed, loop]
	//speed: the speed of the song - this is measured in how many ticks this row will last, much like a tracker
	//loop: which row to loop back to after this one is finished
//the rest of the indices are the note data for each channel
	//[note, instrument, <sound id>, gain, fade, pitch*]
	//note: which note to play - the provided macros range from C-0 to C-7 which should be enough for most applications
		//nothing is prohibiting you from using any pitches you want, but be aware of how gm's pitch multiplier works - i don't think i can do much about this
		//the macros have been tuned against famitracker's default pitches, and a full list is present at the top of fnsGMAPU
	//instrument: which instrument to use for this note
		//this cannot be changed mid-note
	//<sound id>: this will do nothing but is needed so the indices here line up with the enums i used for internal functions
	//gain: what gain this note should be played at
	//fade: uses an array to determine what gain to fade to (starting at the gain argument) and how fast to fade to it (in ms, this uses audio_sound_gain())
	//pitch: offset to the note, calculated internally by adding this offset to the note when playing a note
		//*: this one CANNOT use -1 to continue the previous entry because -1 is a valid pitch offset
	
/// @description basic test song demonstrating all of the available features
function musTest2()
{
	var _arr = [];
	var i = 0;
	_arr[i++] = [[15, __], [nG_1, __PIANO,_, 1.00, [0, 1000], 0], [nAs3, __PULSE,_, 0.40, __, -1  ], [nG_3, __PULSE,_, 0.40, __, 0],	[nD_3, __PULSE,_, 0.40, __, 0]	];
	_arr[i++] = [[__, __], [n___, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, -1  ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, __], [n___, __     ,_, __  , __       , 0], [n___, __     ,_, 0.25, __, 0   ], [n___, __     ,_, 0.25, __, 0],	[n___, __     ,_, 0.25, __, 0]	];
	_arr[i++] = [[__, __], [n___, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, __], [nFs1, __     ,_, __  , [0, 500] , 0], [nA_3, __     ,_, 0.40, __, 0   ], [nFs3, __     ,_, 0.40, __, 0],	[nC_3, __     ,_, 0.40, __, 0]	];
	_arr[i++] = [[__, __], [n___, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, __], [nD_1, __     ,_, __  , [0, 1000], 0], [n___, __     ,_, 0.25, __, 0   ], [n___, __     ,_, 0.25, __, 0],	[n___, __     ,_, 0.25, __, 0]	];
	_arr[i++] = [[__, __], [n___, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, __], [nF_1, __     ,_, __  , [0, 1000], 0], [nGs3, __     ,_, 0.40, __, 0   ], [nF_3, __     ,_, 0.40, __, 0],	[nB_2, __     ,_, 0.40, __, 0]	];
	_arr[i++] = [[__, __], [n___, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, __], [nG_1, __     ,_, __  , __       , 0], [n___, __     ,_, 0.25, __, 0   ], [n___, __     ,_, 0.25, __, 0],	[n___, __     ,_, 0.25, __, 0]	];
	_arr[i++] = [[__, __], [nF_1, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, __], [nE_1, __     ,_, __  , [0, 650] , 0], [nG_3, __     ,_, 0.40, __, 0   ], [nE_3, __     ,_, 0.40, __, 0],	[nAs2, __     ,_, 0.40, __, 0]	];
	_arr[i++] = [[__, __], [n___, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, __], [nC_1, __     ,_, __  , __       , 0], [n___, __     ,_, 0.25, __, 0   ], [n___, __     ,_, 0.25, __, 0],	[n___, __     ,_, 0.25, __, 0]	];
	_arr[i++] = [[__, __], [n___, __     ,_, __  , [0, 100] , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, __], [nDs1, __     ,_, __  , __       , 0], [nFs3, __     ,_, 0.40, __, 0   ], [nDs3, __     ,_, 0.40, __, 0],	[nA_2, __     ,_, 0.40, __, 0]	];
	_arr[i++] = [[__, __], [n___, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, __], [nD_1, __     ,_, __  , __       , 0], [n___, __     ,_, 0.25, __, 0   ], [n___, __     ,_, 0.25, __, 0],	[n___, __     ,_, 0.25, __, 0]	];
	_arr[i++] = [[__, __], [nC_1, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, __], [nD_1, __     ,_, __  , __       , 0], [nF_3, __     ,_, 0.40, __, 0   ], [nD_3, __     ,_, 0.40, __, 0],	[nGs2, __     ,_, 0.40, __, 0]	];
	_arr[i++] = [[__, __], [nC_1, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, __], [nAs0, __     ,_, __  , __       , 0], [n___, __     ,_, 0.25, __, 0   ], [n___, __     ,_, 0.25, __, 0],	[n___, __     ,_, 0.25, __, 0]	];
	_arr[i++] = [[__, __], [nA_0, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[6 , __], [nFs0, __     ,_, 0   , [1 , 100], 0], [nD_3, __     ,_, 0.40, __, 0   ], [nA_2, __     ,_, 0.40, __, 0],	[nFs2, __     ,_, 0.40, __, 0]	];
	_arr[i++] = [[__, __], [n___, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[7 , __], [nC_1, __     ,_, 0   , [1 , 100], 0], [n___, __     ,_, 0.25, __, 0   ], [n___, __     ,_, 0.25, __, 0],	[n___, __     ,_, 0.25, __, 0]	];
	_arr[i++] = [[__, __], [n___, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[8 , __], [nAs0, __     ,_, 0   , [1 , 100], 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, __], [n___, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[9 , __], [nA_0, __     ,_, 0   , [1 , 100], 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	_arr[i++] = [[__, 24], [n___, __     ,_, __  , __       , 0], [n___, __     ,_, __  , __, 0   ], [n___, __     ,_, __  , __, 0],	[n___, __     ,_, __  , __, 0]	];
	return _arr;
}