const std = @import("std");
const Reader = std.fs.File.Reader;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub fn Graph(comptime T: type) type {
    return struct {
        const Self = @This();
        vertices: ArrayList(*Vertex),
        edges: ArrayList(*Edge),
        allocator: Allocator,

        // Vertex and Edge Structs
        // Incidences implemented as a ArrayList
        const Incidence = ArrayList(?*Edge);

        pub const Vertex = struct {
            name: T,
            index: u64,
            incidence: Incidence
        };

        pub const Edge = struct {
            weight: u64,
            index: u64,
            v1: *Vertex,
            v2: *Vertex,
            incidenceSpot1: **Edge, // Will be ptr to self inside a Vertex incidence
            incidenceSpot2: **Edge, // same as above but for other Vertex it connects
        };

        pub fn readFromFile(self: *Self, fileName: [:0]const u8) !void {

            // TODO: Leave this in? Good to deinit cause could mem leak, but maybe user should handle
            try self.deinit();
            self.vertices = ArrayList(*Vertex).init(self.allocator);
            self.edges = ArrayList(*Edge).init(self.allocator);
            
            const file = try std.fs.cwd().openFile(fileName, .{});
            defer file.close();

            var buf_reader = std.io.bufferedReader(file.reader());
            var in_stream = buf_reader.reader();
            var buf: [1024]u8 = undefined;

            while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {

                if(line.len == 0) {
                    continue;
                } else if(line[0] == '-') {
                    std.debug.print("\ncreating edeg with {s}", .{line});
                       // TODO: Unimplemented
                } else if(line[0] != ' ' and (line[0] != '\n')) {
                    std.debug.print("\ncreating vertex: {s}", .{line});

                    try self.vertices.append( try self.createVertex(self.allocator, line));
                    // TODO: Still unimplmented
                }
            }

            // TODO to be continued...
        }

        fn createVertex(self: *Self, allocator: Allocator, name: []u8) !*Vertex {
            var vert = try allocator.create(Vertex);
            vert.name = name;
            vert.index = self.vertices.items.len;
            vert.incidence = Incidence.init(allocator);
            return vert;
        }

        pub fn deinit(self: *Self) !void {
            // TODO: Do I need to check if 0? Might be handled internally
            if(self.edges.items.len != 0) {
                self.edges.deinit();
            }
            for (self.vertices.items) |edge| {
                edge.incidence.deinit();
            }
            if(self.vertices.items.len != 0) {
                self.vertices.deinit();
            }
        }

        pub fn init(allocator: Allocator) !Self {
            return Self{
                .vertices = ArrayList(*Vertex).init(allocator),
                .edges = ArrayList(*Edge).init(allocator),
                .allocator = allocator
            };
        }
    };
}
