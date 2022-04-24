const std = @import("std");

pub fn Graph(comptime T: type) type {
    return struct { // Graph itself
        const Self = @This();

        // Vertex and Edge Structs //TODO: should incidence be own struct? Edges will need pointers to there specific spot in specific incidence (double ptr)
        pub const Vertex = struct { name: T, index: u64, incidence: []?*Edge };

        pub const Edge = struct {};

        pub fn readFromFile() void {
            
        }
    };
}
