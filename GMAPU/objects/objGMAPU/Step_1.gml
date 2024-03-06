/// @description Clock processing
if (__playing)
{
	if (!time_source_exists(__songClock))
	{
		__GMAPU_init_song_clock();
	}
}