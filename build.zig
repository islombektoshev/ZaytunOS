const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86,
            .os_tag = .freestanding,
            .abi = .none,
        },
    });
    const optimize = b.standardOptimizeOption(.{});

    const kernelObj = b.addObject(.{
        .name = "kernel.o",
        .root_source_file = b.path("kernel.zig"),
        .target = target,
        .optimize = optimize,
    });

    const bootObj = b.addAssembly(.{
        .name = "boot.o",
        .target = target,
        .optimize = optimize,
        .source_file = b.path("boot.asm"),
    });

    const kernelExe = b.addExecutable(.{
        .name = "kernel",
        .target = target,
        .optimize = optimize,
    });

    kernelExe.addObject(bootObj);
    kernelExe.addObject(kernelObj);
    kernelExe.setLinkerScriptPath(b.path("linker.ld"));

    b.installArtifact(kernelExe);
}
