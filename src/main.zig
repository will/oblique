const std = @import("std");
const fs = std.fs;

const Strats = blk: {
    @setEvalBranchQuota(200_000);
    const stratFile = @embedFile("strats.txt");

    var result: []const []const u8 = &.{};

    var lines = std.mem.splitScalar(u8, stratFile, '\n');
    while (lines.next()) |line| {
        if (line.len > 0) {
            result = result ++ [1][]const u8{line};
        }
    }

    break :blk result;
};

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const seed = @as(u64, @bitCast(std.time.milliTimestamp()));
    var prng = std.rand.DefaultPrng.init(seed);
    const idx = prng.random().uintLessThan(usize, Strats.len);

    try stdout.print("{s}\n", .{Strats[idx]});

    try bw.flush();
}

test "data parsed correctly" {
    try std.testing.expect(Strats.len > 200);
    for (Strats) |strat| {
        try std.testing.expect(strat.len > 5);
    }
}
