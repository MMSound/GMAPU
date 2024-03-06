/// @description Controlling
if (keyboard_check_pressed(vk_space))
{
	if (!__playing)
	{
		GMAPU_playback_start();
	}
	else
	{
		GMAPU_playback_pause();
	}
}

if (keyboard_check_pressed(vk_f2))
{
	GMAPU_destroy();
}