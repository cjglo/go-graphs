const std = @import("std");
const Reader = std.fs.File.Reader;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const MemError = std.mem.Allocator.Error;
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

        pub const Vertex = struct { name: []const u8, index: u64, incidence: Incidence, visited: bool };

        pub const Edge = struct {
            weight: u64,
            index: u64,
            v1: *Vertex,
            v2: *Vertex,
            incidenceSpot1: **Edge, // Will be ptr to self inside a Vertex incidence
            incidenceSpot2: **Edge, // same as above but for other Vertex it connects
        };

        // map used for Dijkstra's
        const HashMap = std.array_hash_map.AutoArrayHashMap(*Vertex, u64);

        // for Dijkstra's
        const Heap = std.PriorityQueue(*Edge, u64, edgeSort);

        pub fn findShortestPath(self: *Self, vertName1: [:0]const u8, vertName2: [:0]const u8) !u64 {
            const vert1: *Vertex = try self.findVertexByName(vertName1);
            const vert2: *Vertex = try self.findVertexByName(vertName2);

            var map = HashMap.init(self.allocator);
            defer map.deinit();

            for (self.vertices.items) |vert| {
                try map.put(vert, std.math.maxInt(u64));
            }

            return self.dijkstras(vert1, vert2, &map, 0);
        }

        pub fn readFromFile(self: *Self, fileName: [:0]const u8) !void {
            _ = T; // TODO: Current issue marked:  can't think of good reason to have generics

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
                    var i: u32 = 2; // first 2 chars will be '-' and ' ' so info starts @ 2
                    var weight: u32 = 0;
                    var base: u32 = 10;
                    while ('0' <= line[i] and line[i] <= '9') : (i += 1) {
                        const digit = line[i] - '0';
                        weight *= base;
                        weight += digit;
                    }

                    i += 1;
                    var j = i;
                    while (line[j] != ' ') {
                        j += 1;
                    }
                    var name1: []u8 = line[i..j];

                    j += 1;
                    i = j;
                    while (j < line.len and line[j] != ' ') {
                        j += 1;
                    }
                    var name2: []u8 = line[i..j];

                    try self.createEdge(self.allocator, weight, name1, name2);
                } else if (line[0] != ' ' and (line[0] != '\n')) {
                    try self.createVertex(self.allocator, line);
                }
            }
        }

        pub fn doesNameExistInGraph(self: Self, name: [:0]const u8) bool {
            for (self.vertices.items) |vert| {
                if (std.mem.eql(u8, vert.name, name)) return true;
            }
            return false;
        }

        // === Private Functions and init/deinit ===

        fn dijkstras(self: *Self, begin: *Vertex, end: *Vertex, map: *HashMap, path: u64) MemError!u64 {
            if (begin == end) {
                return map.get(begin).?;
            }
            begin.visited = true;

            // step 1
            updateNeighbors(begin, map, path);

            // step 2
            var neighbors = try self.createQueueOfNeighbors(begin); // could make pointer instead return copy, not sure if better

            defer neighbors.deinit();

            var answer: u64 = std.math.maxInt(u64);
            while (neighbors.peek() != null) {
                var edge: *Edge = neighbors.remove();
                var potentialAnswer: u64 = undefined;
                if (edge.v1 == begin) {
                    potentialAnswer = self.dijkstras(edge.v2, end, map, path + edge.weight) catch std.math.maxInt(u64);
                } else if (edge.v2 == begin) {
                    potentialAnswer = self.dijkstras(edge.v1, end, map, path + edge.weight) catch std.math.maxInt(u64);
                }
                if (potentialAnswer < answer) {
                    answer = potentialAnswer;
                }
            }
            self.setAllAsUnvisited();

            return answer;
        }

        fn createQueueOfNeighbors(self: Self, origin: *Vertex) MemError!Heap {
            // Pushing edges for now seems like path of least resitance, can change later
            var neighbors = Heap.init(self.allocator, 1);
            errdefer neighbors.deinit();
            for (origin.incidence.items) |edge| {
                if ((edge.v1 == origin and !edge.v2.visited) or (edge.v2 == origin and !edge.v1.visited)) {
                    try neighbors.add(edge);
                }
            }
            return neighbors;
        }

        // for std lb sorting method in createQueueOfNeighbors
        fn edgeSort(num: u64, edge1: *Edge, edge2: *Edge) std.math.Order {
            _ = num; // TODO: what is this usually used for?

            if (edge1.weight < edge2.weight) {
                return std.math.Order.lt;
            } else if (edge1.weight > edge2.weight) {
                return std.math.Order.gt;
            } else {
                return std.math.Order.eq;
            }
        }

        fn updateNeighbors(current: *Vertex, map: *HashMap, path: u64) void {
            // reminder: incidence is list of ptrs to all edges touching vert
            for (current.incidence.items) |edge| {
                // using unreachable since this is review project and not robust data struct lib
                if (current == edge.v1) {
                    const currentDist = map.get(edge.v2) orelse std.math.maxInt(u64);
                    if (currentDist > path + edge.weight) map.put(edge.v2, path + edge.weight) catch unreachable;
                } else if (current == edge.v2) {
                    const currentDist = map.get(edge.v1) orelse std.math.maxInt(u64);
                    if (currentDist > path + edge.weight) map.put(edge.v1, path + edge.weight) catch unreachable;
                }
            }
        }

        fn setAllAsUnvisited(self: Self) void {
            for (self.vertices.items) |vert| {
                vert.visited = false;
            }
        }

        fn createVertex(self: *Self, allocator: Allocator, name: []u8) !void {
            var vert = try allocator.create(Vertex);

            var nameClone = try allocator.alloc(u8, name.len);
            for (name) |char, i| {
                nameClone[i] = char;
            }

            vert.name = nameClone;
            vert.incidence = Incidence.init(allocator);
            vert.index = self.vertices.items.len;
            vert.visited = false;
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

        fn findVertexByName(self: *Self, name: []const u8) GraphError!*Vertex {
            for (self.vertices.items) |vert| {
                if (std.mem.eql(u8, vert.name, name)) return vert;
            }
            return GraphError.VertexNotFound;
        }

        pub fn deinit(self: *Self) !void {
            self.edges.deinit();

            for (self.vertices.items) |vert| {
                vert.incidence.deinit();
                self.allocator.free(vert.name);
            }
            self.vertices.deinit();
        }

        pub fn init(allocator: Allocator) !Self {
            return Self{ .vertices = ArrayList(*Vertex).init(allocator), .edges = ArrayList(*Edge).init(allocator), .allocator = allocator };
        }
    };
}
