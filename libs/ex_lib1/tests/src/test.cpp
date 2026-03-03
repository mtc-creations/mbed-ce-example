#include "ex_lib1/ex_lib1.hpp"

#include <catch2/catch_test_macros.hpp>
#include <fmt/format.h>

TEST_CASE("a test")
{
    ex_lib1::example_function("test");
}