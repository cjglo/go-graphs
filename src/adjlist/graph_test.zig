const std = @import("std");
const graph = @import("graph.zig");

const TestError = error{ Unimplemented, GraphInitFailure };

// == Tests ==

test "Expect blank Graph to be initialized succesfully" {
    const g = graph.Graph([]const u8);

    if(@TypeOf(g) != type) {
        return TestError.GraphInitFailure;
    }
}

test "Expect ReadFromFile to initialize Graph successfully" {
    return TestError.Unimplemented;
}

test "Expect FindShortestPath to return shortest path from \"a\" to \"g\" to be 15" {
    return TestError.Unimplemented;
}

test "Expect FindShortestPath to return shortest path from \"f\" to \"d\" to be 17" {
    return TestError.Unimplemented;
}

test "Expect DoesNameExistInGraph to return true for \"a\"" {
    return TestError.Unimplemented;
}

test "Expect DoesNameExistInGraph to return false for \"z\"" {
    return TestError.Unimplemented;
}
