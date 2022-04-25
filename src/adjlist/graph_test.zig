const std = @import("std");
const graph = @import("graph.zig");

const TestError = error{ Unimplemented, GraphInitFailure };

// == Tests ==

// TODO Remove first test in future
test "Expect blank Graph to be initialized succesfully" {
    _ = graph.Graph([]const u8);
}

test "Expect ReadFromFile to initialize Graph successfully" {
    return error.SkipZigTest;
}

test "Expect FindShortestPath to return shortest path from \"a\" to \"g\" to be 15" {
    return error.SkipZigTest;
}

test "Expect FindShortestPath to return shortest path from \"f\" to \"d\" to be 17" {
    return error.SkipZigTest;
}

test "Expect DoesNameExistInGraph to return true for \"a\"" {
    return error.SkipZigTest;
}

test "Expect DoesNameExistInGraph to return false for \"z\"" {
    return error.SkipZigTest;
}
