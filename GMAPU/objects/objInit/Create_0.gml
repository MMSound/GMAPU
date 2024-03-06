/// @description Variables
GMAPU_init();

global.gameFont = font_add_sprite_ext(sprFont, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-.,':!?#", false, 0);
draw_set_font(global.gameFont);