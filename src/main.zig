const std = @import("std");
const testing = std.testing;

// == Red Black Tree Impl in Zig ==

fn TreeNode(comptime T: type) type {
    const Self = @This();
    return struct { value: T, left: ?@TypeOf(Self), right: ?@TypeOf(Self) };
}

// == Tests == TODO Move to seperate file
test "TreeNode builds" {
    var my_node = TreeNode(i32){
        .value = 1,
        .left = null,
        .right = null,
    };
    my_node.left = TreeNode(i32){ .value = 0, .left = null, .right = null };
    std.debug.print("my node: {}", .{my_node});
    try testing.expect(1 == 1);
}
