const std = @import("std");
const Reader = std.fs.File.Reader;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub fn Graph(comptime T: type) type {
    return struct {
        const Self = @This();
        vertices: []*Vertex,
        edges: []*Edge,
        allocator: Allocator,

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

        pub fn readFromFile(self: *Self, fileName: [:0]const u8, allocator: ?Allocator) !void {

            // TODO necessary? Make not optional because why would someone pass null alloc?  Can't think of reason, but null handling is always best?
            if(allocator) |allo| {
                self.allocator = allo;
            } else {
                // default is general purpose allocator
                var gpa = std.heap.GeneralPurposeAllocator(.{}){};
                self.allocator = gpa.allocator();
            }
            
            const file = try std.fs.cwd().openFile(fileName, .{});
            defer file.close();

            var buf_reader = std.io.bufferedReader(file.reader());
            var in_stream = buf_reader.reader();
            var buf: [1024]u8 = undefined;

            while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
                std.debug.print("{s}", .{line});
            }

            // TODO to be continued...
        }
    };
}
