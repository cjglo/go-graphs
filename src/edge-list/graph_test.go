package edgelist


import (
	// "fmt"
	"testing"
)




func TestInitGraph(t *testing.T) {
    
	_, err := ReadFromFile("example_graph.txt")
	if err != nil {
		t.Errorf("Failed to initialize graph: " + err.Error())
	}
}