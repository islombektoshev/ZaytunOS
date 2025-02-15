#include "vga.h"


uint16_t  *VGA_PT = (uint16_t* const) 0xB8000;
uint16_t const VGA_DEFAULT_COLOR = (COLOR8_LIGHT_GREY << 8) | (COLOR8_BLACK << 12);

uint16_t vga_sc_line = 0;
uint16_t vga_sc_col = 0;
uint16_t vga_color = VGA_DEFAULT_COLOR;



void vga_reset() {
    vga_sc_line = 0;
    vga_sc_col = 0;
    vga_color = VGA_DEFAULT_COLOR;
    for (uint16_t y = 0; y <  VGA_HEIGHT; y++) {
        for (uint16_t x = 0; x <  VGA_WIDTH; x++) {
            VGA_PT[y*VGA_WIDTH + x] = ' ' | vga_color;
        }
    }
}

void vga_new_line(){
    if(vga_sc_line < VGA_HEIGHT - 1 ) {
        vga_sc_line++;
    } else {
        vga_scroll_up();
        vga_sc_col = 0;
    }
}

void vga_scroll_up() {
    for(uint16_t y = 1; y < VGA_HEIGHT; y++) {
        for (uint16_t x = 0; x < VGA_WIDTH; x++) {
            VGA_PT[(y-1) * VGA_WIDTH + x] = VGA_PT[y*VGA_WIDTH+x];
        }
    }

    for (uint16_t x = 0; x < VGA_WIDTH; x++) {
        VGA_PT[(VGA_HEIGHT-1) * VGA_WIDTH + x] = ' ' | vga_color;
    }
}
void vga_print(const char* s) {
    while(*s) {
        switch(*s) {
            case '\n':
                vga_new_line();
                break;
            case '\r':
                vga_sc_col = 0;
                break;
            case '\t':
                for(int i = 0; i < 4; i++) {
                    if(vga_sc_col == VGA_WIDTH) {
                        vga_new_line();
                    }
                    VGA_PT[vga_sc_line*VGA_WIDTH + (vga_sc_col++)] = ' ' | vga_color;
                }
                break;
            default:
                if (vga_sc_col == VGA_WIDTH) {
                    vga_new_line();
                }

                VGA_PT[vga_sc_line*VGA_WIDTH + (vga_sc_col++)] = *s | vga_color;
                break;
        }
        s++;
    }
}

