pub const COLOR8 = struct {
    pub const BLACK: u16 = 0;
    pub const LIGHT_GREY: u16 = 7;
};

pub const DEF_WIDTH = 80;
pub const DEF_HEIGHT = 25;

// pub const VGA_PR: [DEF_WIDTH * DEF_HEIGHT]u16 = @ptrFromInt(0xB8000);
pub const VGA_PR: [*]u16 = @ptrFromInt(0xB8000);
pub const DEFAULT_COLOR = (COLOR8.LIGHT_GREY << 8) | (COLOR8.BLACK << 12);

const Self = @This();

line: u16 = 0,
col: u16 = 0,
color: u16 = DEFAULT_COLOR,

pub fn new() Self {
    return Self{};
}

pub fn reset(vga: *Self) void {
    vga.line = 0;
    vga.col = 0;
    vga.color = DEFAULT_COLOR;
    for (0..DEF_HEIGHT) |y| {
        for (0..DEF_WIDTH) |x| {
            VGA_PR[y * DEF_WIDTH + x] = ' ' | vga.color;
        }
    }
}

pub fn newLine(vga: *Self) void {
    if (vga.line < DEF_HEIGHT - 1) {
        vga.line += 1;
    } else {
        vga.scrollUp();
        vga.col = 0;
    }
}

pub fn scrollUp(vga: *Self) void {
    for (1..DEF_HEIGHT) |y| {
        for (0..DEF_WIDTH) |x| {
            VGA_PR[(y - 1) * DEF_WIDTH + x] = VGA_PR[y * DEF_WIDTH + x];
        }
    }
    for (0..DEF_WIDTH) |x| {
        VGA_PR[(DEF_HEIGHT - 1) * DEF_WIDTH + x] = ' ' | vga.color;
    }
}

pub fn print(vga: *Self, line: []const u8) void {
    for (line) |s| {
        switch (s) {
            '\n' => {
                vga.newLine();
            },
            '\r' => {
                vga.col = 0;
            },
            '\t' => {
                for (0..4) |_| {
                    if (vga.col == DEF_WIDTH) {
                        vga.newLine();
                    }
                    VGA_PR[vga.line * DEF_WIDTH + vga.col] = ' ' | vga.color;
                    vga.col += 1;
                }
            },
            else => {
                if (vga.col == DEF_WIDTH) {
                    vga.newLine();
                }
                VGA_PR[vga.line * DEF_WIDTH + vga.col] = s | vga.color;
                vga.col += 1;
            },
        }
    }
}
