const std = @import("std");
const Allocator = std.mem.Allocator;
const Reader = std.fs.File.Reader;
const ArrayList = std.ArrayList;

pub fn Graph(comptime T: type) type {
    return struct {
        const Self = @This();
        vertices: []*Vertex,
        edges: []*Edge,

        // Vertex and Edge Structs
        // Incidences implemented as a slice
        pub const Vertex = struct { name: T, index: u64, incidence: []?*Edge };

        pub const Edge = struct {
            weight: u64,
            index: u64,
            v1: *Vertex,
            v2: *Vertex,
            incidenceSpot1: **Edge, // Will be ptr to self inside a Vertex incidence
            incidenceSpot2: **Edge, // same as above but for other Vertex it connects
        };

        pub fn readFromFile(self: *Self, fileName: [:0]const u8) !void {
            const file = try std.fs.cwd().openFile(fileName, .{});
            defer file.close();

            _ = self;

            // TODO working on reading file and allocating to slice
            // TODO check out methods docs as well to understand rules of method and params
            // var content = std.ArrayList(u8).init()
        }
    };
}
