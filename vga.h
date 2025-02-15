#pragma once
#include "stdint.h"


// defining anci color
#define COLOR8_BLACK 0
#define COLOR8_LIGHT_GREY 7

#define VGA_WIDTH 80
#define VGA_HEIGHT 25


void vga_print(const char* s);
void vga_scroll_up();
void vga_new_line();
void vga_reset();
