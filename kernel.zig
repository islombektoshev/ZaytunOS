const Vga = @import("vga.zig");

pub export fn kmain() void {
    var vga = Vga.new();
    vga.reset();
    vga.print("Salom Bilol");
}
