const std = @import("std");
const graph = @import("graph.zig");

const TestError = error{ LeftDidNotEqualRight, CanNotFindNameInGraph, FoundNameInGraphThatDoesNotExist };
var gpa = std.heap.GeneralPurposeAllocator(.{}){};

// === Tests ===
test "Expect ReadFromFile to initialize Graph w/o error" {
    var allocator = gpa.allocator();
    var g = try graph.Graph().init(allocator); // take type and just initialize it
    g.deinit();
    var g2 = try graph.Graph().init(allocator);
    defer g2.deinit();
    try g2.readFromFile("example_graph.txt");
}

test "Expect FindShortestPath to return shortest path from \"a\" to \"g\" to be 15" {
    var allocator = gpa.allocator();
    var g = try graph.Graph().init(allocator); // take type and just initialize it
    defer g.deinit();
    try g.readFromFile("example_graph.txt");
    // actual test
    const dist = try g.findShortestPath("a", "f");
    if (dist != 15) return TestError.LeftDidNotEqualRight;
}

test "Expect FindShortestPath to return shortest path from \"f\" to \"d\" to be 17" {
    var allocator = gpa.allocator();
    var g = try graph.Graph().init(allocator); // take type and just initialize it
    defer g.deinit();
    try g.readFromFile("example_graph.txt");
    // actual test
    const dist = try g.findShortestPath("f", "d");
    if (dist != 17) return TestError.LeftDidNotEqualRight;
}

test "Expect doesNameExistInGraph to return true for \"a\"" {
    var allocator = gpa.allocator();
    var g = try graph.Graph().init(allocator); // take type and just initialize it
    defer g.deinit();
    try g.readFromFile("example_graph.txt");
    // actual test
    if (!g.doesNameExistInGraph("a")) return TestError.CanNotFindNameInGraph;
}

test "Expect doesNameExistInGraph to return false for \"z\"" {
    var allocator = gpa.allocator();
    var g = try graph.Graph().init(allocator); // take type and just initialize it
    defer g.deinit();
    try g.readFromFile("example_graph.txt");
    //actual test
    if (g.doesNameExistInGraph("z")) return TestError.FoundNameInGraphThatDoesNotExist;
}