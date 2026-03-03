#include "ex_lib1/ex_lib1.hpp"
#include <cstdio>

ex_lib1::Example_Class::Example_Class() {}

void ex_lib1::example_function(std::span<const char> str)
{
    printf("[ex_lib1]: %.*s\n", str.size(), str.data());
}