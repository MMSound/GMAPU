/// @description Drawing

//none of this draw code is strictly necessary i just thought it would be cool for a demo
draw_text_transformed(8, 8, "GMAPU", 2.00, 2.00, 0);
draw_text(96, 8, "BY MINIMACRO SOUND");

draw_set_color(#415d66);
draw_text(4, 24, "SAMPLE-BASED MUSIC IN GAMEMAKER");
draw_set_color(#71a6a1);
draw_text(16, 40, $"CHANNELS: {GMAPU_CHANNEL_COUNT}");

for (var i = 0; i < GMAPU_CHANNEL_COUNT; i++)
{
	var _baseCol = [13, 32, 48];
	var _val = audio_sound_get_gain(__channelInfo[i][__GMAPU_SONG_DATA.SOUNDID]);
	var _r = clamp(round_to(lerp(_baseCol[0], 255, _val), 4), 0, 255);
	var _g = clamp(round_to(lerp(_baseCol[1], 255, _val), 4), 0, 255);
	var _b = clamp(round_to(lerp(_baseCol[2], 255, _val), 4), 0, 255);
	
	draw_set_color(make_color_rgb(_r, _g, _b));
	draw_text((16 + (i * 32)), 48, __GMAPU_get_note_name(__channelInfo[i][__GMAPU_SONG_DATA.NOTE]));
	draw_set_color(c_white);
}

if (time_source_exists(__songClock))
{
	draw_set_color(#71a6a1);
	draw_text(16, 64, $"ROW: {array_length(__songData) - time_source_get_reps_remaining(__songClock)}");
	draw_text(16, 72, $"SPEED: {__songSpeed}");
	draw_set_color(#415d66);
	draw_text(16, 80, $"TIME ON ROW REMAINING: {time_source_get_time_remaining(__songClock)}");
}
else
{
	draw_set_color(#415d66);
}

draw_text(16, 88, $"FPS: {fps}");
draw_text(16, 96, $"REAL FPS: {fps_real}");
draw_set_color(c_white);

draw_text(8, 128, $"SPACE - {__playing ? (__paused ? "RESUME" : "PAUSE") : "START"}\nF2 - RESET");