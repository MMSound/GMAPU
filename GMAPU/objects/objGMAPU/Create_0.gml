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

//[note, instrument, soundid (set to 0 in song data), gain]
var i = 0;
#region Test Song 1
/*__songData[i++] = [12, [nC_3, __PIANO, 0, 1.00],	[nC_1, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nC_3, __PIANO, 0, 0.25],	[nOFF, __PULSE, 0, 1.00]];
__songData[i++] = [6 , [nF_3, __PIANO, 0, 1.00],	[nC_1, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nC_3, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [12, [nG_3, __PIANO, 0, 1.00],	[nAs0, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nF_3, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [6 , [nF_3, __PIANO, 0, 1.00],	[nC_1, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nG_3, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [12, [nC_4, __PIANO, 0, 1.00],	[nDs1, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nF_3, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [6 , [nAs3, __PIANO, 0, 1.00],	[nC_1, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nC_4, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [12, [nG_3, __PIANO, 0, 1.00],	[nAs0, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nAs3, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [6 , [nAs3, __PIANO, 0, 1.00],	[nC_1, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nG_3, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [12, [nOFF, __PIANO, 0, 1.00],	[nC_1, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [n___, __PIANO, 0, 0.25],	[nOFF, __PULSE, 0, 1.00]];
__songData[i++] = [6 , [nDs4, __PIANO, 0, 1.00],	[nC_1, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [n___, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [12, [n___, __PIANO, 0, 1.00],	[nAs0, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [n___, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [6 , [nF_4, __PIANO, 0, 1.00],	[nC_1, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nDs4, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [12, [nDs4, __PIANO, 0, 1.00],	[nDs1, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nF_4, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [6 , [nC_4, __PIANO, 0, 1.00],	[nC_1, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nDs4, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [12, [nAs3, __PIANO, 0, 1.00],	[nAs0, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nC_4, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];
__songData[i++] = [6 , [nC_4, __PIANO, 0, 1.00],	[nC_1, __PULSE, 0, 1.00]];
__songData[i++] = [-1, [nAs3, __PIANO, 0, 0.25],	[n___, __PULSE, 0, 1.00]];*/
#endregion
#region Test Song 2
__songData[i++] = [12, [nG_4, __PULSE, 0, 1.00], [nAs3, __PULSE, 0, 0.75], [nG_3, __PULSE, 0, 0.75],	[nD_3, __PULSE, 0, 0.75]	];
__songData[i++] = [11, [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [n___, -1     , 0, -1  ], [n___, -1     , 0, 0.25], [n___, -1     , 0, 0.25],	[n___, -1     , 0, 0.25]	];
__songData[i++] = [11, [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nFs4, -1     , 0, -1  ], [nA_3, -1     , 0, 0.75], [nFs3, -1     , 0, 0.75],	[nC_3, -1     , 0, 0.75]	];
__songData[i++] = [11, [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nD_4, -1     , 0, -1  ], [n___, -1     , 0, 0.25], [n___, -1     , 0, 0.25],	[n___, -1     , 0, 0.25]	];
__songData[i++] = [11, [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nF_4, -1     , 0, -1  ], [nGs3, -1     , 0, 0.75], [nF_3, -1     , 0, 0.75],	[nB_2, -1     , 0, 0.75]	];
__songData[i++] = [11, [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nG_4, -1     , 0, -1  ], [n___, -1     , 0, 0.25], [n___, -1     , 0, 0.25],	[n___, -1     , 0, 0.25]	];
__songData[i++] = [11, [nF_4, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nE_4, -1     , 0, -1  ], [nG_3, -1     , 0, 0.75], [nE_3, -1     , 0, 0.75],	[nAs2, -1     , 0, 0.75]	];
__songData[i++] = [11, [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nC_4, -1     , 0, -1  ], [n___, -1     , 0, 0.25], [n___, -1     , 0, 0.25],	[n___, -1     , 0, 0.25]	];
__songData[i++] = [11, [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nDs4, -1     , 0, -1  ], [nFs3, -1     , 0, 0.75], [nDs3, -1     , 0, 0.75],	[nA_2, -1     , 0, 0.75]	];
__songData[i++] = [11, [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nD_4, -1     , 0, -1  ], [n___, -1     , 0, 0.25], [n___, -1     , 0, 0.25],	[n___, -1     , 0, 0.25]	];
__songData[i++] = [11, [nC_4, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nD_4, -1     , 0, -1  ], [nF_3, -1     , 0, 0.75], [nD_3, -1     , 0, 0.75],	[nGs2, -1     , 0, 0.75]	];
__songData[i++] = [11, [nC_4, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nAs3, -1     , 0, -1  ], [n___, -1     , 0, 0.25], [n___, -1     , 0, 0.25],	[n___, -1     , 0, 0.25]	];
__songData[i++] = [11, [nA_3, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nFs3, -1     , 0, -1  ], [nD_3, -1     , 0, 0.75], [nA_2, -1     , 0, 0.75],	[nFs2, -1     , 0, 0.75]	];
__songData[i++] = [11, [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nC_4, -1     , 0, -1  ], [n___, -1     , 0, 0.25], [n___, -1     , 0, 0.25],	[n___, -1     , 0, 0.25]	];
__songData[i++] = [11, [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nAs3, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [11, [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [12, [nA_3, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
__songData[i++] = [11, [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ], [n___, -1     , 0, -1  ],	[n___, -1     , 0, -1  ]	];
#endregion



window_set_size(256 * 3, 240 * 3);