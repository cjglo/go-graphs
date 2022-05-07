const std = @import("std");
const Reader = std.fs.File.Reader;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const GraphError = error{VertexNotFound};

pub fn Graph(comptime T: type) type {
    return struct {
        const Self = @This();
        vertices: ArrayList(*Vertex),
        edges: ArrayList(*Edge),
        allocator: Allocator,

        // Vertex and Edge Structs
        // Incidences implemented as a ArrayList
        const Incidence = ArrayList(*Edge);

        pub const Vertex = struct { name: T, index: u64, incidence: Incidence };

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
                if (line.len == 0) {
                    continue;
                } else if (line[0] == '-') {
                    std.debug.print("\ncreating edeg with {s}\n", .{line});

                    var i: u32 = 2; // first 2 chars will be '-' and ' ' so info starts @ 2
                    var weight: u32 = 0;
                    var base: u32 = 1;
                    while ('0' <= line[i] and line[i] <= '9') : (base *= 10) {
                        const digit = line[i] - '0';
                        weight += digit * base;
                        i += 1;
                    }
                    std.debug.print("\n Weight: {}", .{weight});

                    i += 1;
                    var j = i;
                    while (line[j] != ' ') {
                        j += 1;
                    }
                    var name1: []u8 = line[i..j];
                    std.debug.print("\n name1:{s}:", .{name1});

                    j += 1;
                    i = j;
                    while (j < line.len and line[j] != ' ') {
                        j += 1;
                    }
                    var name2: []u8 = line[i..j];
                    std.debug.print("\n name2:{s}:", .{name2});

                    try self.createEdge(self.allocator, weight, name1, name2);
                } else if (line[0] != ' ' and (line[0] != '\n')) {
                    std.debug.print("\ncreating vertex: {s}", .{line});
                    try self.createVertex(self.allocator, line);
                }
            }

            // TODO to be continued...
        }

        fn createVertex(self: *Self, allocator: Allocator, name: []u8) !void {
            var vert = try allocator.create(Vertex);

            std.debug.print("\ninside, creating: {s}", .{name});
            var nameClone = try allocator.alloc(u8, name.len);
            for (name) |char, i| {
                nameClone[i] = char;
            }

            vert.name = nameClone;
            vert.incidence = Incidence.init(allocator);
            vert.index = self.vertices.items.len;
            // decided to append rather than return because of vert.index.  Could cause issues to set index, but have outer function append
            // not an issue to just append since this is private and will always want to append if this is run anyway
            try self.vertices.append(vert);
        }

        fn createEdge(self: *Self, allocator: Allocator, weight: u32, v1name: []u8, v2name: []u8) !void {
            var edge = try allocator.create(Edge);
            edge.weight = weight;

            const v1 = try self.findVertexByName(v1name);
            const v2 = try self.findVertexByName(v2name);
            edge.v1 = v1;
            edge.v2 = v2;

            const index1 = v1.incidence.items.len;
            try v1.incidence.append(edge);
            edge.incidenceSpot1 = &v1.incidence.items[index1]; // pointer to the pointer inside incidence

            const index2 = v2.incidence.items.len;
            try v2.incidence.append(edge);
            edge.incidenceSpot2 = &v2.incidence.items[index2]; // same as above but for vertex 2

            edge.index = self.edges.items.len;
            // decided to append rather than return because of edge.index.  Could cause issues to set index, but have outer function append
            try self.edges.append(edge);
        }

        fn findVertexByName(self: *Self, name: []u8) GraphError!*Vertex {
            for (self.vertices.items) |vert| {
                std.debug.print("\nvert-name: {s}", .{vert.name});
                std.debug.print("\nsearch-name: {s}", .{name});

                if (std.mem.eql(u8, vert.name, name)) return vert;
            }
            return GraphError.VertexNotFound;
        }

        pub fn deinit(self: *Self) !void {
            // TODO: Do I need to check if 0? Might be handled internally
            if (self.edges.items.len != 0) {
                self.edges.deinit();
            }
            for (self.vertices.items) |edge| {
                edge.incidence.deinit();
            }
            if (self.vertices.items.len != 0) {
                self.vertices.deinit();
                // TODO: Need to deallocate names as well
            }
        }

        pub fn init(allocator: Allocator) !Self {
            return Self{ .vertices = ArrayList(*Vertex).init(allocator), .edges = ArrayList(*Edge).init(allocator), .allocator = allocator };
        }
    };
}
