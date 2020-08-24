
#include "jlcxx/jlcxx.hpp"
#include "jlcxx/array.hpp"
#include "jlcxx/functions.hpp"

namespace calc
{
    double add(double x, double y)
    {
        return x + y;
    }

    double sub(double x, double y)
    {
        return x - y;
    }

    double mul(double x, double y)
    {
        return x * y;
    }

    double cxxdiv(double x, double y)
    {
        return x / y;
    }

    JLCXX_MODULE define_julia_module(jlcxx::Module &mod)
    {
        mod.method("add", &add);
        mod.method("sub", &sub);
        mod.method("mul", &mul);
        mod.method("cxxdiv", &cxxdiv);
    }
} // namespace calc