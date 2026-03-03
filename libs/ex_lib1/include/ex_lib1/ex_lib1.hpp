#ifndef COMPONENT1_HPP
#define COMPONENT1_HPP

#include <span>

namespace ex_lib1
{
    class Example_Class
    {
    public:
        explicit Example_Class();
    };

    void example_function(std::span<const char> a_span);
} // namespace ex_lib1

#endif