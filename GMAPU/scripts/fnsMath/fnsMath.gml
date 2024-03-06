//general math functions that probably aren't necessary for GMAPU to work

/// @description rounds a number to the nearest given number
function round_to(_val, _mult)
{
	return (round(_val / _mult) * _mult);
}
