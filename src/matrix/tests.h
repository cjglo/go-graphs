#ifndef __TESTS_H_
#define __TESTS_H_

#include "graph.h"
#include <iostream>
#include <string>

#define IS_TRUE(x) { if (!(x)) std::cout << __FUNCTION__ << " failed on line " << __LINE__ << std::endl; else std::cout << __FUNCTION__ << " Successfully Passed" << std::endl; }

#endif